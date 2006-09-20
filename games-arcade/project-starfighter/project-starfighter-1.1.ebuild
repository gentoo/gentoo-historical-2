# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/project-starfighter/project-starfighter-1.1.ebuild,v 1.13 2006/09/20 16:48:48 blubb Exp $

inherit eutils games

MY_P=${P/project-/}
DESCRIPTION="A space themed shooter"
HOMEPAGE="http://www.parallelrealities.co.uk/starfighter.php"
# FIXME: Parallel Realities uses a lame download script.
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

DEPEND="media-libs/libsdl
	media-libs/sdl-image
	media-libs/sdl-mixer"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e "s:-O3:${CXXFLAGS}:" makefile \
		|| die "sed makefile failed"
	epatch "${FILESDIR}"/${PV}-ammo.patch
}

src_compile() {
	emake DATA="${GAMES_DATADIR}/parallelrealities/" || die "emake failed"
}

src_install() {
	dogamesbin starfighter || die "dogamesbin failed"
	insinto "${GAMES_DATADIR}/parallelrealities/"
	doins starfighter.pak || die "doins failed"
	dohtml -r docs/
	prepgamesdirs
}
