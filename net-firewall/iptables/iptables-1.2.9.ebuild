# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-firewall/iptables/iptables-1.2.9.ebuild,v 1.19 2005/03/09 10:16:31 robbat2 Exp $

inherit eutils flag-o-matic

DESCRIPTION="Linux kernel (2.4+) firewall, NAT and packet mangling tools"
HOMEPAGE="http://www.iptables.org/"
SRC_URI="http://www.iptables.org/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc alpha sparc hppa ~mips ia64 amd64"
IUSE="ipv6"

# iptables is dependent on kernel sources.  Strange but true.
DEPEND="virtual/os-headers"
RDEPEND=""

src_unpack() {
	replace-flags -O0 -O2

	unpack ${A} ; cd ${S}

	epatch ${FILESDIR}/${PV}-files

	# The folowing hack is needed because ${ARCH} is "sparc" and not "sparc64"
	# and epatch uses ??_${ARCH}_foo.${EPATCH_SUFFIX} when reading from directories
	[ "${PROFILE_ARCH}" = "sparc64" ] && epatch ${FILESDIR}/sparc64_limit_fix.patch.bz2

	chmod +x extensions/.IMQ-test*
	chmod +x extensions/.childlevel-test*
	chmod +x extensions/.layer7-test*

	sed -i -e "s:-O2:${CFLAGS} -Iinclude:g" -e "s:/usr/local::g" -e "s:-Iinclude/::" Makefile
}

src_compile() {
	check_KV

	# prevent it from causing ICMP errors.
	# http://bugs.gentoo.org/show_bug.cgi?id=23645
	filter-flags "-fstack-protector"

	# iptables and libraries are now installed to /sbin and /lib, so that
	# systems with remote network-mounted /usr filesystems can get their
	# network interfaces up and running correctly without /usr.

	use ipv6 && myconf="${myconf} DO_IPV6=1" || myconf="${myconf} DO_IPV6=0"

	make ${myconf} \
		LIBDIR=/lib \
		BINDIR=/sbin \
		MANDIR=/usr/share/man \
		INCDIR=/usr/include \
		KERNEL_DIR=/usr/src/linux \
		|| die
}

src_install() {
	make DESTDIR=${D} MANDIR=/usr/share/man ${myconf} install || die
	make DESTDIR=${D} ${myconf} \
		LIBDIR=/usr/lib \
		MANDIR=/usr/share/man \
		INCDIR=/usr/include \
		install-devel || die

	dodoc COPYING
	dodir /var/lib/iptables ; keepdir /var/lib/iptables
	exeinto /etc/init.d
	newexe ${FILESDIR}/iptables.init iptables
	insinto /etc/conf.d
	newins ${FILESDIR}/iptables.confd iptables

	if use ipv6; then
		dodir /var/lib/ip6tables ; keepdir /var/lib/ip6tables
		exeinto /etc/init.d
		newexe ${FILESDIR}/ip6tables.init ip6tables
		insinto /etc/conf.d
		newins ${FILESDIR}/ip6tables.confd ip6tables
	fi
}

pkg_postinst() {
	einfo "This package now includes an initscript which loads and saves"
	einfo "rules stored in /var/lib/iptables/rules-save"
	einfo "This location can be changed in /etc/conf.d/iptables"
	einfo ""
	einfo "If you are using the iptables initsscript you should save your"
	einfo "rules using the new iptables version before rebooting."
	einfo ""
	einfo "If you are upgrading to a >=2.4.21 kernel you may need to rebuild"
	einfo "iptables."
}
