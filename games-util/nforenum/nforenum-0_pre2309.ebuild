# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-util/nforenum/nforenum-0_pre2309.ebuild,v 1.1 2010/04/08 22:14:55 mr_bones_ Exp $

EAPI=2
inherit eutils toolchain-funcs

MY_PV=${PV/0_pre/r}
DESCRIPTION="A tool checking NFO code for errors"
HOMEPAGE="http://binaries.openttd.org/extra/nforenum/"
SRC_URI="http://binaries.openttd.org/extra/nforenum/${MY_PV}/${PN}-${MY_PV}-source.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

S=${WORKDIR}/${PN}-${MY_PV}

DEPEND="dev-libs/boost
	dev-lang/perl"
RDEPEND=""

src_prepare() {
	cat > Makefile.local <<-__EOF__
		CC = $(tc-getCC)
		CXX = $(tc-getCXX)
		CFLAGS = ${CFLAGS}
		CXXFLAGS = ${CXXFLAGS}
		LDOPT = ${LDFLAGS}
		STRIP = :
		V = 1
	__EOF__

	epatch "${FILESDIR}"/${P}-build.patch
}

src_install() {
	dobin renum || die
	dodoc doc/*.en.txt || die
}
