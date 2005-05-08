# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/ppp/ppp-2.4.3-r3.ebuild,v 1.2 2005/05/08 14:45:44 tove Exp $

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Point-to-Point Protocol (PPP)"
HOMEPAGE="http://www.samba.org/ppp"
SRC_URI="ftp://ftp.samba.org/pub/ppp/${P}.tar.gz
	mirror://gentoo/${P}-patches-20050505.tar.gz
	dhcp? ( http://www.netservers.co.uk/gpl/ppp-dhcpc.tgz )"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~sparc ~x86 ~ppc64"
IUSE="gtk ipv6 activefilter pam atm mppe-mppc dhcp"

RDEPEND="virtual/libc
	activefilter? ( virtual/libpcap )
	atm? ( net-dialup/linux-atm )
	pam? ( sys-libs/pam )
	gtk? ( =x11-libs/gtk+-1* )"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${WORKDIR}/patch/ppp_flags.patch
	epatch ${WORKDIR}/patch/mpls.patch
	epatch ${WORKDIR}/patch/killaddr-smarter.patch

	epatch ${WORKDIR}/patch/upstream-fixes.patch
	epatch ${WORKDIR}/patch/fix_activefilter.patch

	use mppe-mppc && {
		einfo "Enabling mppe-mppc support"
		epatch ${WORKDIR}/patch/mppe-mppc-1.1.patch
	}

	use atm && {
		einfo "Enabling PPPoATM support"
		sed -i "s/^#HAVE_LIBATM=yes/HAVE_LIBATM=yes/" ${S}/pppd/plugins/pppoatm/Makefile.linux
	}

	use activefilter || {
		einfo "Disabling active filter"
		sed -i "s/^FILTER=y/#FILTER=y/" pppd/Makefile.linux
	}

	use pam && {
		einfo "Enabling PAM"
		sed -i "s/^#USE_PAM=y/USE_PAM=y/" pppd/Makefile.linux
	}

	use ipv6 && {
		einfo "Enabling IPv6"
		sed -i "s/#HAVE_INET6/HAVE_INET6/" pppd/Makefile.linux
	}

	einfo "Enabling CBCP"
	sed -i "s/^#CBCP=y/CBCP=y/" ${S}/pppd/Makefile.linux

	use dhcp && {
		# copy the ppp-dhcp plugin files
		einfo "Copying ppp-dhcp plugin files..."
		tar -xzf ${DISTDIR}/ppp-dhcpc.tgz -C ${S}/pppd/plugins/
		sed -i 's/SUBDIRS := rp-pppoe/SUBDIRS := rp-pppoe dhcp/' ${S}/pppd/plugins/Makefile.linux
		sed -i "s/-O2/${CFLAGS} -fPIC/" ${S}/pppd/plugins/dhcp/Makefile.linux
		epatch ${FILESDIR}/ppp-sys_error_to_strerror.patch || die
	}

	find ${S} -type f -name Makefile.linux \
		-exec sed -i -e '/^CC[[:space:]]*=/d' {} \;
}

src_compile() {
	export CC="$(tc-getCC)"
	export AR="$(tc-getAR)"
	append-ldflags -Wl,-z,now
	econf || die "configuration failed"
	emake COPTS="${CFLAGS}" || die "compile failed"

	#build pppgetpass
	cd contrib/pppgetpass
	if use gtk; then
		emake -f Makefile.linux || die "failed to build pppgetpass"
	else
		emake pppgetpass.vt || die "failed to build pppgetpass"
	fi
}

src_install() {
	local y
	for y in chat pppd pppdump pppstats
	do
		doman ${y}/${y}.8
		dosbin ${y}/${y}
	done
	chmod u+s-w ${D}/usr/sbin/pppd

	dosbin pppd/plugins/rp-pppoe/pppoe-discovery

	insinto /etc/ppp
	insopts -m0600
	newins etc.ppp/pap-secrets pap-secrets.example
	newins etc.ppp/chap-secrets chap-secrets.example

	insopts -m0644
	doins etc.ppp/options
	doins ${FILESDIR}/${PV}/options-pptp
	doins ${FILESDIR}/${PV}/options-pppoe
	doins ${FILESDIR}/${PV}/chat-default

	insopts -m0755
	doins ${FILESDIR}/ip-up
	doins ${FILESDIR}/ip-down

	exeinto /etc/init.d/
	doexe ${FILESDIR}/net.ppp0

	if use pam; then
		insinto /etc/pam.d
		insopts -m0644
		newins pppd/ppp.pam ppp || die "not found ppp.pam"
	fi

	insinto /etc/conf.d
	insopts -m0600
	newins ${FILESDIR}/confd.ppp0 net.ppp0

	local PLUGINS_DIR=/usr/lib/pppd/$(awk -F '"' '/VERSION/ {print $2}' pppd/patchlevel.h)
	#closing " for sintax coloring
	dodir ${PLUGINS_DIR}
	insinto ${PLUGINS_DIR}
	insopts -m0755
	doins pppd/plugins/minconn.so || die "minconn.so not build"
	doins pppd/plugins/passprompt.so || die "passprompt.so not build"
	doins pppd/plugins/passwordfd.so || die "passwordfd.so not build"
	doins pppd/plugins/winbind.so || die "winbind.so not build"
	doins pppd/plugins/rp-pppoe/rp-pppoe.so || die "rp-pppoe.so not build"
	doins pppd/plugins/radius/radius.so || die "radius.so not build"
	doins pppd/plugins/radius/radattr.so || die "radattr.so not build"
	doins pppd/plugins/radius/radrealms.so || die "radrealms.so not build"
	if use atm; then
		doins pppd/plugins/pppoatm/pppoatm.so || die "pppoatm.so not build"
	fi
	if use dhcp; then
		doins pppd/plugins/dhcp/dhcpc.so || die "dhcpc.so not build"
	fi

	insinto /etc/modules.d
	insopts -m0644
	newins ${FILESDIR}/${PV}/modules.ppp ppp
	if use mppe-mppc; then
		echo 'alias ppp-compress-18 ppp_mppe_mppc' >> ${D}/etc/modules.d/ppp
	fi

	dodoc PLUGINS README* SETUP Changes-2.3 FAQ
	dodoc ${FILESDIR}/${PV}/README.mpls
	dohtml ${FILESDIR}/${PV}/pppoe.html

	doman pppd/plugins/radius/pppd-radius.8
	doman pppd/plugins/radius/pppd-radattr.8

	dosbin scripts/pon
	dosbin scripts/poff
	dosbin scripts/plog
	doman scripts/pon.1

	# Adding misc. specialized scripts to doc dir
	dodir /usr/share/doc/${PF}/scripts/chatchat
	insinto	/usr/share/doc/${PF}/scripts/chatchat
	doins scripts/chatchat/*
	insinto /usr/share/doc/${PF}/scripts
	doins scripts/*

	if use gtk; then
		dosbin contrib/pppgetpass/{pppgetpass.vt,pppgetpass.gtk}
		newsbin contrib/pppgetpass/pppgetpass.sh pppgetpass
	else
		newsbin contrib/pppgetpass/pppgetpass.vt pppgetpass
	fi
	doman contrib/pppgetpass/pppgetpass.8
}

pkg_postinst() {
	if [ ! -e ${ROOT}dev/.devfsd ] && [ ! -e ${ROOT}dev/.udev ]
	then
		if [ ! -e ${ROOT}dev/ppp ]; then
			mknod ${ROOT}dev/ppp c 108 0
		fi
	fi
	if [ "$ROOT" = "/" ]
	then
		/sbin/update-modules
	fi
	ewarn "To enable kernel-pppoe read html/pppoe.html in the doc-directory."
	ewarn "Note: the library name has changed from pppoe.so to rp-pppoe.so."
	ewarn "Pon, poff and plog scripts have been supplied for experienced users."
	ewarn "New users or those requiring something more should have a look at"
	ewarn "the /etc/init.d/net.ppp0 script."
	ewarn "Users needing particular scripts (ssh,rsh,etc.)should check out the"
	ewarn "/usr/share/doc/ppp*/scripts directory."

	# lib name has changed
	sed -i -e "s:^pppoe.so:rp-pppoe.so:" ${ROOT}etc/ppp/options
}
