# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-engines/scummvm/scummvm-0.6.0.ebuild,v 1.5 2004/06/01 04:25:34 vapier Exp $

inherit games

DESCRIPTION="Reimplementation of the SCUMM game engine used in Lucasarts adventures"
HOMEPAGE="http://scummvm.sourceforge.net/"
SRC_URI="mirror://sourceforge/scummvm/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc ~amd64 ~sparc"
IUSE="alsa debug mad oggvorbis sdl zlib"

DEPEND="virtual/glibc
	virtual/x11
	>media-libs/libmpeg2-0.3.1
	sdl? ( >=media-libs/libsdl-1.2.2 )
	oggvorbis? (
		media-libs/libogg
		media-libs/libvorbis
	)
	alsa? ( >=media-libs/alsa-lib-0.9 )
	mad? ( media-libs/libmad )
	zlib? ( sys-libs/zlib )"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PV}-gcc34.patch
}

src_compile() {
	local myconf=

	use sdl \
		&& myconf="${myconf} --backend=sdl" \
		|| myconf="${myconf} --backend=x11"
	use debug \
		|| myconf="${myconf} --disable-debug"

	# not an autoconf script so dont call econf
	./configure \
		`use_enable alsa` \
		`use_enable mad` \
		`use_enable oggvorbis vorbis` \
		`use_enable zlib` \
		${myconf} \
		|| die "configure failed"
	emake || die "emake failed"
}

src_install() {
	dogamesbin scummvm || die "dobin failed"
	doman scummvm.6
	dodoc NEWS README TODO
	insinto /usr/share/pixmaps
	doins scummvm.xpm      || die "doins failed"
	make_desktop_entry scummvm ScummVM
	prepgamesdirs
}
