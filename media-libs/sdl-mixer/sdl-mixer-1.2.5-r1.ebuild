# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/sdl-mixer/sdl-mixer-1.2.5-r1.ebuild,v 1.4 2003/09/25 23:43:53 msterret Exp $

MY_P="${P/sdl-/SDL_}"
S=${WORKDIR}/${MY_P}
DESCRIPTION="Simple Direct Media Layer Mixer Library"
HOMEPAGE="http://www.libsdl.org/projects/SDL_mixer/index.html"
SRC_URI="http://www.libsdl.org/projects/SDL_mixer/release/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc ~alpha amd64"
IUSE="mpeg mikmod oggvorbis"

DEPEND=">=media-libs/libsdl-1.2.5
	>=sys-apps/sed-4
	>=media-libs/smpeg-0.4.4-r1
	mikmod? ( >=media-libs/libmikmod-3.1.10 )
	oggvorbis? ( >=media-libs/libvorbis-1.0_beta4 )"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PV}-gcc3.patch
	autoreconf
	sed -i \
		-e 's:/usr/local/lib/timidity:/usr/share/timidity:' \
			timidity/config.h || die "sed timidity/config.h failed"
}

src_compile() {
	econf \
		`use_enable mikmod mod` \
		`use_enable mpeg music-mp3` \
		`use_enable oggvorbis music-ogg` \
		|| die
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodoc CHANGES COPYING README
}
