# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-engines/exult/exult-1.1.10_rc2.ebuild,v 1.4 2004/06/24 22:38:20 agriffis Exp $

inherit games

MY_P="${P/_}"
DESCRIPTION="an Ultima 7 game engine that runs on modern operating systems"
HOMEPAGE="http://exult.sourceforge.net/"
SRC_URI="mirror://sourceforge/exult/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc ~sparc"
IUSE="timidity zlib opengl debug mmx 3dnow"

DEPEND=">=media-libs/libsdl-1.2*
	>=media-libs/sdl-mixer-1.2.4
	timidity? ( >=media-sound/timidity++-2* )
	zlib? ( sys-libs/zlib )
	opengl? ( virtual/opengl )"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	ewarn "*********************************************************"
	ewarn " I had massive problems with exult when using aggressive"
	ewarn " CFLAGS and CXXFLAGS. If exult segfaults try less"
	ewarn " aggressive optimizations and/or a different -march"
	ewarn " e.g.: -march=i386 instead of -march=i686 on x86"
	ewarn "*********************************************************"
}

src_compile() {
	egamesconf \
		$(use_enable timidity) \
		$(use_enable zlib zip) \
		$(use_enable opengl) \
		$(use_enable debug) \
		$(use_enable mmx) \
		$(use_enable 3dnow) \
			|| die
	# bug #44185 - fails on parallel make
	emake -j1 || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	cp -R "${D}/${GAMES_DATADIR}"/{applications,icons} "${D}/usr/share/" \
		|| die "cp failed"
	dodoc AUTHORS ChangeLog NEWS FAQ README README.1ST
	prepgamesdirs
}

pkg_postinst() {
	einfo "To hear music in exult, you have to install a timidity-patch."
	einfo "Try this:"
	einfo "		$ emerge timidity-eawpatches"
	einfo "kernel drivers. Install alsa instead."
	einfo
	einfo "You *must* have the original Ultima7 The Black Gate and/or"
	einfo "The Serpent Isle installed. "
	einfo "See /usr/doc/${PF}/README.gz for infos!"
}
