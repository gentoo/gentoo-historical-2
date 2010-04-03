# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/brainparty/brainparty-0.5.ebuild,v 1.3 2010/04/03 15:32:26 mr_bones_ Exp $

EAPI=2
inherit eutils games

DESCRIPTION="A puzzle-solving, brain-stretching game for all ages"
HOMEPAGE="http://www.tuxradar.com/brainparty"
SRC_URI="http://www.tuxradar.com/files/brainparty/brainparty${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libsdl[audio,opengl,video]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-ttf
	media-libs/sdl-image[png]
	media-libs/sdl-gfx"

S=${WORKDIR}/${PN}

src_prepare() {
	sed -i \
		-e 's/$(LIBS) $(OSXCOMPAT) $(OBJFILES)/$(OSXCOMPAT) $(OBJFILES) $(LIBS)/' \
		-e 's/CXXFLAGS = .*/CXXFLAGS+=-c/' \
		-e '/^CXX =/d' \
		-e '/-o brainparty/s/INCLUDES) /&$(LDFLAGS) /' \
		Makefile \
		|| die "sed failed"
	sed -i \
		"/^int main(/ a\\\\tchdir(\"${GAMES_DATADIR}/${PN}\");\n" \
		main.cpp \
		|| die "sed failed"
	epatch "${FILESDIR}"/${P}-savegame.patch

}

src_install() {
	dogamesbin brainparty || die
	insinto "${GAMES_DATADIR}/${PN}/Content"
	doins Content/* || die
	newicon Content/icon.bmp ${PN}.bmp
	make_desktop_entry brainparty "Brain Party" /usr/share/pixmaps/${PN}.bmp
	prepgamesdirs
}
