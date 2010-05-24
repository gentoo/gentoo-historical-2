# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/mednafen/mednafen-0.8.12.ebuild,v 1.4 2010/05/24 09:40:42 tupone Exp $

EAPI=2
inherit autotools eutils games

DESCRIPTION="An advanced NES, GB/GBC/GBA, TurboGrafx 16/CD, NGPC and Lynx emulator"
HOMEPAGE="http://mednafen.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/mednafen-${PV/12/C}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="alsa cjk debug jack nls"

RDEPEND="virtual/opengl
	media-libs/libsndfile
	dev-libs/libcdio
	media-libs/libsdl
	media-libs/sdl-net
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/${PN}

src_prepare() {
	sed -i \
		-e 's:$(datadir)/locale:/usr/share/locale:' \
		-e 's:$(localedir):/usr/share/locale:' \
		$(find . -name 'Makefile.*') \
		|| die 'sed failed'
	sed -i \
		-e '/-fomit-frame-pointer/d' \
		-e '/-ffast-math/d' \
		configure.ac \
		|| die "sed failed"
	epatch "${FILESDIR}"/${P}-gcc45.patch
	eautoreconf
}

src_configure() {
	egamesconf \
		--disable-dependency-tracking \
		$(use_enable alsa) \
		$(use_enable cjk cjk-fonts) \
		$(use_enable debug debugger) \
		$(use_enable jack) \
		$(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc Documentation/cheats.txt AUTHORS ChangeLog TODO
	dohtml Documentation/*
	prepgamesdirs
}
