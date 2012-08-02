# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-engines/scummvm/scummvm-1.5.0.ebuild,v 1.1 2012/08/02 23:02:25 mr_bones_ Exp $

EAPI=2
inherit eutils flag-o-matic games

DESCRIPTION="Reimplementation of the SCUMM game engine used in Lucasarts adventures"
HOMEPAGE="http://scummvm.sourceforge.net/"
SRC_URI="mirror://sourceforge/scummvm/${P/_/}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="alsa debug flac fluidsynth freetype mp3 vorbis"
RESTRICT="test"  # it only looks like there's a test there #77507

RDEPEND=">=media-libs/libsdl-1.2.2[audio,joystick,video]
	>media-libs/libmpeg2-0.3.1
	sys-libs/zlib
	vorbis? ( media-libs/libogg media-libs/libvorbis )
	alsa? ( media-libs/alsa-lib )
	mp3? ( media-libs/libmad )
	flac? ( media-libs/flac )
	freetype? ( media-libs/freetype:2 )
	fluidsynth? ( media-sound/fluidsynth )"
DEPEND="${RDEPEND}
	x86? ( dev-lang/nasm )"

S=${WORKDIR}/${P/_/}

src_prepare() {
	# -g isn't needed for nasm here
	sed -i \
		-e '/NASMFLAGS/ s/-g//' \
		configure || die
	sed -i \
		-e '/INSTALL.*doc/d' \
		-e '/INSTALL.*\/pixmaps/d' \
		-e 's/-s //' \
		ports.mk || die
}

src_configure() {
	local myconf

	# bug #137547
	use fluidsynth || myconf="${myconf} --disable-fluidsynth"

	use x86 && append-ldflags -Wl,-z,noexecstack

	# NOT AN AUTOCONF SCRIPT SO DONT CALL ECONF
	./configure \
		--backend=sdl \
		--host=$CHOST \
		--enable-verbose-build \
		--prefix=/usr \
		--bindir="${GAMES_BINDIR}" \
		--datadir="${GAMES_DATADIR}"/${PN} \
		--libdir="${GAMES_LIBDIR}" \
		--enable-zlib \
		$(use_enable debug) \
		$(use_enable alsa) \
		$(use_enable mp3 mad) \
		$(use_enable flac) \
		$(use_enable vorbis) \
		$(use_enable freetype freetype2) \
		$(use_enable x86 nasm) \
		${myconf} || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS NEWS README TODO
	doicon icons/scummvm.svg
	make_desktop_entry scummvm ScummVM scummvm "Game;AdventureGame"
	prepgamesdirs
}
