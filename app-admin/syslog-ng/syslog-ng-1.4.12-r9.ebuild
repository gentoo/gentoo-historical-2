# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/app-admin/syslog-ng/syslog-ng-1.4.12-r9.ebuild,v 1.2 2002/07/17 20:43:17 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Syslog-ng is a syslog replacement with advanced filtering features"
SRC_URI="http://www.balabit.hu/downloads/syslog-ng/1.4/${P}.tar.gz"
SLOT="0"
HOMEPAGE="http://www.balabit.hu/en/products/syslog-ng/"

RDEPEND="virtual/glibc >=dev-libs/libol-0.2.23"
DEPEND="sys-devel/flex"
LICENSE="GPL-2"
SLOT="0"

src_compile() {
	./configure --host=${CHOST} \
		--prefix=/usr || die
	emake CFLAGS="${CFLAGS} -I/usr/include/libol -D_GNU_SOURCE" \
		prefix=${D}/usr all || die "compile problem"
}

src_install() {
	make prefix=${D}/usr install || die
	rm -rf ${D}/usr/share/man

	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS PORTS README
	cd doc
	dodoc syslog-ng.conf.sample syslog-ng.conf.demo stresstest.sh
	doman syslog-ng.8 syslog-ng.conf.5
	cd ${S}/doc/sgml
	dodoc syslog-ng.dvi syslog-ng.html.tar.gz syslog-ng.ps syslog-ng.sgml syslog-ng.txt

	dodir /etc/syslog-ng
	insinto /etc/syslog-ng
	doins ${FILESDIR}/syslog-ng.conf.sample

	exeinto /etc/init.d
	newexe ${FILESDIR}/syslog-ng.rc6 syslog-ng
}
