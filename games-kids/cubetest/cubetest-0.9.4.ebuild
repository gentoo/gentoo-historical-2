# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-kids/cubetest/cubetest-0.9.4.ebuild,v 1.8 2009/06/23 16:58:53 mr_bones_ Exp $

EAPI=2
inherit eutils qt4 games

DESCRIPTION="A program to train your spatial insight"
HOMEPAGE="http://www.vandenoever.info/software/cubetest/"
SRC_URI="http://www.vandenoever.info/software/cubetest/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND="x11-libs/qt-gui:4
	x11-libs/qt-core:4[qt3support]"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	local i

	epatch "${FILESDIR}"/${P}-build.patch
	for i in $(find  src/ -iname *_moc.cpp) ; do
		moc ${i/_moc.cpp/.h} -o $i || die
	done
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	prepgamesdirs
}
