# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/prboom/prboom-2.4.1.ebuild,v 1.4 2006/06/10 12:33:05 vapier Exp $

inherit eutils toolchain-funcs games

DESCRIPTION="Port of ID's doom to SDL and OpenGL"
HOMEPAGE="http://prboom.sourceforge.net/"
SRC_URI="mirror://sourceforge/prboom/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"
IUSE="opengl"

DEPEND=">=media-libs/libsdl-1.1.3
	media-libs/sdl-mixer
	media-libs/sdl-net
	opengl? ( virtual/opengl virtual/glu )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	ebegin "Detecting NVidia GL/prboom bug"
	$(tc-getCC) "${FILESDIR}"/${PV}-nvidia-test.c 2> /dev/null
	local ret=$?
	eend ${ret} "NVidia GL/prboom bug found ;("
	[ ${ret} -eq 0 ] || epatch "${FILESDIR}"/${PV}-nvidia.patch
}

src_compile() {
	local myconf
	# configure.in should be fixed as
	# --enable-gl and 
	# --disable-gl are treated the same
	use opengl && myconf="--enable-gl"
	# leave --disable-cpu-opt in otherwise the configure script
	# will append -march=i686 and crap ... let the user's CFLAGS
	# handle this ...
	egamesconf \
		${myconf} \
		$(use_enable x86 i386-asm) \
		--disable-cpu-opt \
		|| die
	# configure script screws up a few things
	sed -i \
		-e "/DOOMWADDIR/s:\".*\":\"${GAMES_DATADIR}/doom-data\":" config.h \
		|| die "sed failed"
	emake || die "emake failed"
}

src_install() {
	dogamesbin src/prboom{,-game-server} || die "dogamesbin failed"

	insinto "${GAMES_DATADIR}/doom-data"
	doins data/*.wad || die "doins failed"

	doman doc/*.{5,6}
	dodoc AUTHORS NEWS README TODO doc/README.* doc/*.txt

	doicon "${FILESDIR}/${PN}.png"
	make_desktop_entry ${PN} "PrBoom"
	prepgamesdirs
}
