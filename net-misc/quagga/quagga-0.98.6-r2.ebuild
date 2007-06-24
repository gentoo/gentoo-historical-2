# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/quagga/quagga-0.98.6-r2.ebuild,v 1.7 2007/06/24 22:12:10 vapier Exp $

WANT_AUTOMAKE="latest"
WANT_AUTOCONF="latest"

inherit eutils multilib autotools

DESCRIPTION="A free routing daemon replacing Zebra supporting RIP, OSPF and BGP. Includes OSPFAPI, NET-SNMP and IPV6 support."
HOMEPAGE="http://quagga.net/"
SRC_URI="http://www.quagga.net/download/${P}.tar.gz
	mirror://gentoo/${P}-patches-20070412.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 arm hppa ppc s390 sparc x86"
IUSE="ipv6 snmp pam tcpmd5 bgpclassless ospfapi realms fix-connected-rt multipath tcp-zebra"
RESTRICT="userpriv"

DEPEND=">=sys-libs/libcap-1.10-r5
	snmp? ( net-analyzer/net-snmp )
	pam? ( sys-libs/pam )"
RDEPEND="${DEPEND}
	sys-apps/iproute2"

src_unpack() {
	unpack ${A} || die "failed to unpack sources"

	cd "${S}" || die "source dir not found"
	# Fix security quagga bug 355
	epatch "${WORKDIR}/patch/bgpd-bug-355.diff"
	#Patch to fix RIP authentication problem in 0.98.6 (#132353)
	#DO NOT USE IT IN ANY OTHER VERSIONS! 
	epatch "${WORKDIR}/patch/ripd-show-ifaces.diff"

	# TCP MD5 for BGP patch for Linux (RFC 2385) - http://hasso.linux.ee/doku.php/english:network:rfc2385
	use tcpmd5 && epatch "${WORKDIR}/patch/ht-20050321-0.98.2-bgp-md5.patch"

	# Classless prefixes for BGP - http://hasso.linux.ee/doku.php/english:network:quagga
	use bgpclassless && epatch "${WORKDIR}/patch/ht-20040304-classless-bgp.patch"

	# Connected route fix (Amir Guindehi) - http://voidptr.sboost.org/quagga/amir-connected-route.patch.bz2
	# Dependant on the use flag 'fix-connected-rt' because it seems that more peoples have troubles 
	# with this than having a benefit.
	# This patch fixes a bad behavior of the Linux kernel routing packets to interfaces which are
	# down. Folks with PtP interfaces and VLans report troubles with this patch. Enable it again
	# if you get a problem because your kernel routes packets to a downed interface.
	use fix-connected-rt && epatch "${WORKDIR}/patch/amir-connected-route.patch"

	# Realms support (Calin Velea) - http://vcalinus.gemenii.ro/quaggarealms.html
	use realms && epatch "${WORKDIR}/patch/${P}-realms.diff"

	# regenerate configure and co if we touch .ac or .am files
	eautoreconf
}

src_compile() {
	local myconf="--disable-static --enable-dynamic"

	use ipv6 \
			&& myconf="${myconf} --enable-ipv6 --enable-ripng --enable-ospf6d --enable-rtadv" \
			|| myconf="${myconf} --disable-ipv6 --disable-ripngd --disable-ospf6d"
	use ospfapi \
			&& myconf="${myconf} --enable-opaque-lsa --enable-ospf-te --enable-ospfclient"
	use snmp && myconf="${myconf} --enable-snmp"
	use pam && myconf="${myconf} --with-libpam"
	use tcpmd5 && myconf="${myconf} --enable-tcp-md5"
	use realms && myconf="${myconf} --enable-realms"
	use multipath && myconf="${myconf} --enable-multipath=0"
	use tcp-zebra && myconf="${myconf} --enable-tcp-zebra"

	econf \
		--enable-nssa \
		--enable-user=quagga \
		--enable-group=quagga \
		--enable-vty-group=quagga \
		--with-cflags="${CFLAGS}" \
		--enable-vtysh \
		--sysconfdir=/etc/quagga \
		--enable-exampledir=/etc/quagga/samples \
		--localstatedir=/var/run/quagga \
		--libdir=/usr/$(get_libdir)/quagga \
		${myconf} \
		|| die "configure failed"
	emake || die "make failed"
}

src_install() {
	einstall \
		localstatedir="${D}/var/run/quagga" \
		sysconfdir="${D}/etc/quagga" \
		exampledir="${D}/etc/quagga/samples" \
		libdir="${D}/usr/$(get_libdir)/quagga" || die "make install failed"

	keepdir /var/run/quagga || die

	local i MY_SERVICES_LIST="zebra ripd ospfd bgpd"
	use ipv6 && MY_SERVICES_LIST="${MY_SERVICES_LIST} ripngd ospf6d"
	for i in ${MY_SERVICES_LIST} ; do
		newinitd "${FILESDIR}/${i}.init" ${i} || die "failed to install ${i} init.d script"
	done
	newconfd "${FILESDIR}/zebra.conf" zebra || die "failed to install zebra conf.d script"

	if use pam; then
		insinto /etc/pam.d
		newins "${FILESDIR}/quagga.pam" quagga
	fi

	newenvd "${FILESDIR}/quagga.env" 99quagga
}

pkg_preinst() {
	enewgroup quagga
	enewuser quagga -1 -1 /var/empty quagga
}

pkg_postinst() {
	# empty dir for pid files for the new priv separation auth
	#set proper owner/group/perms even if dir already existed
	install -d -m0770 -o root -g quagga "${ROOT}/etc/quagga"
	install -d -m0755 -o quagga -g quagga "${ROOT}/var/run/quagga"

	einfo "Sample configuration files can be found in /etc/quagga/samples."
	einfo "You have to create config files in /etc/quagga before"
	einfo "starting one of the daemons."

	if use tcpmd5; then
		echo
		ewarn "TCP MD5 for BGP needs a patched kernel!"
		einfo "See http://hasso.linux.ee/doku.php/english:network:rfc2385 for more info."
	fi

	if use ipv6; then
		echo
		ewarn "This version of quagga contains a netlink race condition fix that triggered a kernel bug"
		ewarn "which affects IPv6 users who have a kernel version < 2.6.13-rc6."
		einfo "See following links for more info:"
		einfo "   http://lists.quagga.net/pipermail/quagga-dev/2005-June/003507.html"
		einfo "   http://bugzilla.quagga.net/show_bug.cgi?id=196"
	fi
}
