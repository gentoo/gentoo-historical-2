# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/prboom/prboom-2.5.0.ebuild,v 1.1 2009/06/01 21:44:25 mr_bones_ Exp $

EAPI=2
inherit eutils toolchain-funcs games

DESCRIPTION="Port of ID's doom to SDL and OpenGL"
HOMEPAGE="http://prboom.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	mirror://gentoo/${PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="media-libs/libsdl
	media-libs/sdl-mixer
	media-libs/sdl-net
	!games-fps/lsdldoom
	virtual/opengl
	virtual/glu"

src_prepare() {
	ebegin "Detecting NVidia GL/prboom bug"
	$(tc-getCC) "${FILESDIR}"/${P}-nvidia-test.c 2> /dev/null
	local ret=$?
	eend ${ret} "NVidia GL/prboom bug found ;("
	[ ${ret} -eq 0 ] || epatch "${FILESDIR}"/${P}-nvidia.patch
	sed -i \
		-e '/^gamesdir/ s/\/games/\/bin/' \
		src/Makefile.in \
		|| die "sed failed"
	sed -i \
		-e 's/: install-docDATA/:/' \
		-e '/^SUBDIRS/ s/doc//' \
		Makefile.in \
		|| die "sed failed"
	sed -i \
		-e 's:-ffast-math $CFLAGS_OPT::' \
		configure \
		|| die "sed configure failed"
}

src_configure() {
	# leave --disable-cpu-opt in otherwise the configure script
	# will append -march=i686 and crap ... let the user's CFLAGS
	# handle this ...
	egamesconf \
		--disable-dependency-tracking \
		--enable-gl \
		$(use_enable x86 i386-asm) \
		--disable-cpu-opt \
		--with-waddir="${GAMES_DATADIR}/doom-data"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	doman doc/*.{5,6}
	dodoc AUTHORS NEWS README TODO doc/README.* doc/*.txt
	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} "PrBoom"
	prepgamesdirs
}
