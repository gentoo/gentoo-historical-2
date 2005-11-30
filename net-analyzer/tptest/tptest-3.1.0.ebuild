# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/tptest/tptest-3.1.0.ebuild,v 1.1.1.1 2005/11/30 10:12:07 chriswhite Exp $

MY_P=${PN}${PV}

DESCRIPTION="Internet bandwidth tester"
HOMEPAGE="http://tptest.sourceforge.net/"
SRC_URI="mirror://sourceforge/tptest/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""
DEPEND=">=sys-apps/sed-4"
#RDEPEND=""
S=${WORKDIR}/build
S0=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}

	mkdir ${S}
	cp ${S0}/engine/* ${S}
	cp ${S0}/os-dep/unix/* ${S}
	cp ${S0}/apps/unix/client/* ${S}

	cd ${S}
	sed -i "28s:$: ${CFLAGS}:g" Makefile
}

src_compile() {
	emake || die
}

src_install() {
	dobin tptest
	dodoc README tptest3.txt
}
