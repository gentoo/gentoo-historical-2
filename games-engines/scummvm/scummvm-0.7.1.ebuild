# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-engines/scummvm/scummvm-0.7.1.ebuild,v 1.4 2005/06/23 00:54:36 agriffis Exp $

inherit eutils games

DESCRIPTION="Reimplementation of the SCUMM game engine used in Lucasarts adventures"
HOMEPAGE="http://scummvm.sourceforge.net/"
SRC_URI="mirror://sourceforge/scummvm/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="alsa debug flac mp3 ogg vorbis sdl zlib"
RESTRICT="test"  # it only looks like there's a test there #77507

RDEPEND=">=media-libs/libsdl-1.2.2
	>media-libs/libmpeg2-0.3.1
	ogg? ( media-libs/libogg media-libs/libvorbis )
	vorbis? ( media-libs/libogg media-libs/libvorbis )
	alsa? ( >=media-libs/alsa-lib-0.9 )
	mp3? ( media-libs/libmad )
	flac? ( media-libs/flac )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	x86? ( dev-lang/nasm )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PV}-configure.patch"
}

src_compile() {
	local myconf="--backend=sdl" # x11 backend no worky (bug #83502)

	use debug \
		|| myconf="${myconf} --disable-debug"
	(use vorbis || use ogg) \
		&& myconf="${myconf} --enable-vorbis" \
		|| myconf="${myconf} --disable-vorbis --disable-mpeg2"

	# NOT AN AUTOCONF SCRIPT SO DONT CALL ECONF
	# mpeg2 support needs vorbis (bug #79149) so turn it off if -oggvorbis
	./configure \
		$(use_enable alsa) \
		$(use_enable mp3 mad) \
		$(use_enable flac) \
		$(use_enable zlib) \
		$(use_enable x86 nasm) \
		${myconf} \
		|| die "configure failed"
	emake || die "emake failed"
}

src_install() {
	dogamesbin scummvm || die "dobin failed"
	doman scummvm.6
	dodoc NEWS README TODO
	doicon scummvm.xpm
	make_desktop_entry scummvm ScummVM
	prepgamesdirs
}
