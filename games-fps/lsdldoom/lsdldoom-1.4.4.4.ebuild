# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/lsdldoom/lsdldoom-1.4.4.4.ebuild,v 1.15 2008/02/15 01:04:11 wolf31o2 Exp $

inherit eutils games

DESCRIPTION="Port of ID's doom to SDL"
HOMEPAGE="http://firehead.org/~jessh/lsdldoom/"
SRC_URI="http://www.lbjhs.net/~jessh/lsdldoom/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc sparc x86"
IUSE=""

DEPEND="media-libs/libsdl
	media-libs/sdl-net
	!games-fps/prboom
	games-fps/doom-data"

src_unpack() {
	unpack ${A}
	cp -r "${S}"{,.orig}
	cd "${S}"
	epatch "${FILESDIR}"/${PV}-gentoo-paths.patch \
		"${FILESDIR}/${P}"-gcc41.patch
	epatch "${FILESDIR}"/${PV}-gcc34.patch #77846
}

src_compile() {
	# The SDL_mixer implementation is VERY broken ...
	# it relies on internal function calls rather than
	# the exported API ... bad programmer !
	# i386-asm -> build failure
	# cpu-opt -> just adds -mcpu crap to CFLAGS
	ac_cv_lib_SDL_mixer_Mix_LoadMUS=no \
	egamesconf \
		--disable-i386-asm \
		--disable-cpu-opt \
		|| die
	emake || die
}

src_install() {
	make install DESTDIR="${D}" || die
	prepalldocs
	dodoc ChangeLog
	prepgamesdirs
}
