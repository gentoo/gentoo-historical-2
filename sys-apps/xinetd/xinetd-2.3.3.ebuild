# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/xinetd/xinetd-2.3.3.ebuild,v 1.2 2001/09/01 06:12:57 woodchip Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Replacement for inetd."
HOMEPAGE="http://www.xinetd.org"
SRC_URI="http://www.xinetd.org/${P}.tar.gz"

DEPEND="virtual/glibc tcpd? ( >=sys-apps/tcp-wrappers-7.6-r2 )"
RDEPEND="virtual/glibc sys-devel/perl"

src_compile() {
	local myconf
	use tcpd && myconf="$myconf--with-libwrap"
	use ipv6 && myconf="$myconf --with-inet6"

	./configure --with-loadavg --prefix=/usr --mandir=/usr/share/man --host=${CHOST} $myconf || die
	# Parallel make does not work
	make || die
}

src_install() {
	cd ${S}
	make prefix=${D}/usr MANDIR=${D}/usr/share/man install
	dodoc CHANGELOG README COPYRIGHT ${FILESDIR}/xinetd.conf

	exeinto /etc/rc.d/init.d
	newexe ${FILESDIR}/xinetd.rc5 xinetd
	doexe ${FILESDIR}/svc-xinetd

	newexe ${FILESDIR}/xinetd-run-${PV}  run
	exeinto /usr/sbin
	doexe ${FILESDIR}/xconv.pl
}
