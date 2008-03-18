# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-util/gslist/gslist-0.8.2.ebuild,v 1.3 2008/03/18 01:50:59 nyhm Exp $

inherit eutils toolchain-funcs games

DESCRIPTION="A GameSpy server browser"
HOMEPAGE="http://aluigi.altervista.org/papers.htm#gslist"
SRC_URI="mirror://gentoo/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-build.patch
	sed -i "s:gcc:$(tc-getCC):" Makefile || die "sed failed"
}

src_install() {
	dogamesbin ${PN} || die "dogamesbin failed"
	dodoc ${PN}.txt
	prepgamesdirs
}
