# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/mod_loopback/mod_loopback-2.0.ebuild,v 1.6 2004/06/25 01:02:43 agriffis Exp $

DESCRIPTION="A web client debugging tool (DSO) for Apache2"
HOMEPAGE="http://www.snert.com/Software/mod_loopback/index.shtml"

S=${WORKDIR}/${P}
SRC_URI="http://www.snert.com/Software/download/${PN}200.tgz"
DEPEND="=net-www/apache-2*"
LICENSE="as-is"
KEYWORDS="x86"
IUSE=""
SLOT="0"

src_compile() {
	apxs2 -c mod_loopback.c || die
}

src_install() {
	exeinto /usr/lib/apache2-extramodules
	doexe .libs/${PN}.so
	insinto /etc/apache2/conf/modules.d
	doins ${FILESDIR}/28_mod_loopback.conf
	dodoc ${FILESDIR}/28_mod_loopback.conf CHANGES.txt LICENSE.txt
}
