# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-engines/scummvm/scummvm-0.13.1.ebuild,v 1.6 2009/07/07 18:15:25 mr_bones_ Exp $

EAPI=2
inherit eutils games

DESCRIPTION="Reimplementation of the SCUMM game engine used in Lucasarts adventures"
HOMEPAGE="http://scummvm.sourceforge.net/"
SRC_URI="mirror://sourceforge/scummvm/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 sparc x86 ~x86-fbsd"
IUSE="alsa debug flac fluidsynth mp3 ogg vorbis"
RESTRICT="test"  # it only looks like there's a test there #77507

RDEPEND=">=media-libs/libsdl-1.2.2[joystick,video]
	>media-libs/libmpeg2-0.3.1
	sys-libs/zlib
	ogg? ( media-libs/libogg media-libs/libvorbis )
	vorbis? ( media-libs/libogg media-libs/libvorbis )
	alsa? ( >=media-libs/alsa-lib-0.9[midi] )
	mp3? ( media-libs/libmad )
	flac? ( media-libs/flac )
	fluidsynth? ( media-sound/fluidsynth )"
DEPEND="${RDEPEND}
	x86? ( dev-lang/nasm )"

src_prepare() {
	# -g isn't needed for nasm here
	sed -i \
		-e '/NASMFLAGS/ s/-g//' \
		Makefile.common \
		|| die "sed failed"
	sed -i \
		-e '/INSTALL.*doc\//d' \
		-e '/INSTALL.*\/pixmaps/d' \
		-e 's/-s //' \
		ports.mk \
		|| die "sed failed"
	epatch "${FILESDIR}"/${P}-glibc210.patch
}

src_configure() {
	local myconf="--backend=sdl" # x11 backend no worky (bug #83502)

	# let the engine find its data files in the right place (bug #178116)
	myconf="${myconf} --datadir=${GAMES_DATADIR}"

	( use vorbis || use ogg ) \
		&& myconf="${myconf} --enable-vorbis" \
		|| myconf="${myconf} --disable-vorbis --disable-mpeg2"

	# bug #137547
	use fluidsynth || myconf="${myconf} --disable-fluidsynth"

	# NOT AN AUTOCONF SCRIPT SO DONT CALL ECONF
	# mpeg2 support needs vorbis (bug #79149) so turn it off if -oggvorbis
	./configure \
		--prefix=/usr \
		--bindir="${GAMES_BINDIR}" \
		--datadir="${GAMES_DATADIR}" \
		--libdir="${GAMES_LIBDIR}" \
		--enable-zlib \
		$(use_enable debug) \
		$(use_enable alsa) \
		$(use_enable mp3 mad) \
		$(use_enable flac) \
		$(use_enable x86 nasm) \
		${myconf} \
		|| die "configure failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS NEWS README TODO
	doicon icons/scummvm.svg
	make_desktop_entry scummvm ScummVM scummvm "Game;AdventureGame"
	prepgamesdirs
}
