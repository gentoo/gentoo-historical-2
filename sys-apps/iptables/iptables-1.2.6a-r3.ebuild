# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/iptables/iptables-1.2.6a-r3.ebuild,v 1.3 2002/10/19 01:52:44 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Kernel 2.4 firewall, NAT and packet mangling tools"
SRC_URI="http://netfilter.samba.org/files/${P}.tar.bz2"
HOMEPAGE="http://www.iptables.org"
KEYWORDS="x86 ppc sparc sparc64"
SLOT="0"
# iptables is dependent on kernel sources.  Strange but true.
DEPEND="virtual/glibc"
RDEPEND="${DEPEND}"
LICENSE="GPL-2"

src_unpack() {
	unpack ${A}
	cd ${S}
	cat ${FILESDIR}/iptables-1.2.6a-imq.diff-3 | patch -p1 || die
	chmod +x extensions/.IMQ-test*
	mv Makefile Makefile.orig
	sed -e "s/-O2/${CFLAGS}/g" -e "s:/usr/local::g" Makefile.orig > Makefile
}

src_compile() {
	# iptables and libraries are now installed to /sbin and /lib, so that
	# systems with remote network-mounted /usr filesystems can get their 
	# network interfaces up and running correctly without /usr.
	
	# use make, not emake
	make \
		LIBDIR=/lib \
		BINDIR=/sbin \
		MANDIR=/usr/share/man \
		INCDIR=/usr/include \
		KERNEL_DIR=/usr/src/linux \
		|| die
}

src_install() {
	dodir /usr/{lib,share/man/man8,sbin}
	make \
		LIBDIR=${D}/lib \
		BINDIR=${D}/sbin \
		MANDIR=${D}/usr/share/man \
		INCDIR=${D}/usr/include \
		install || die

	dodoc COPYING KNOWN_BUGS
	keepdir /var/lib/iptables
	exeinto /etc/init.d
	newexe ${FILESDIR}/iptables.init-2 iptables
	insinto /etc/conf.d
	newins ${FILESDIR}/iptables.confd-2 iptables
}

pkg_postinst() {
	einfo "This package now includes an initscript which loads and saves"
	einfo "rules stored in /var/lib/iptables/rules-save"
	einfo "This location can be changed in /etc/conf.d/iptables"
}
