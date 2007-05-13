# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/tptest/tptest-3.1.7.ebuild,v 1.2 2007/05/13 17:39:02 beandog Exp $

DESCRIPTION="Internet bandwidth tester"
HOMEPAGE="http://tptest.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""
DEPEND=">=sys-apps/sed-4"

S=${WORKDIR}/${P}

src_unpack() {
	unpack ${A}

	cd ${S}/apps/unix/server
	sed -i "s:^CFLAGS\(.*\):CFLAGS\1 ${CFLAGS} :g" Makefile

	cd ${S}/apps/unix/client
	sed -i "s:^CFLAGS\(.*\):CFLAGS\1 ${CFLAGS} :g" Makefile
	cp -f ${S}/os-dep/unix/* .
	cp -f ${S}/engine/* .
}

src_compile() {
	cd ${S}/apps/unix/server
	emake || die

	cd ${S}/apps/unix/client
	emake || die
}

src_install() {
	dobin ${S}/apps/unix/client/tptestclient
	dosbin ${S}/apps/unix/server/tptestserver

	insinto /etc
	doins ${S}/apps/unix/server/tptest.conf
}
