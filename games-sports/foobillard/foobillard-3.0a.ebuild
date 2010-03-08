# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-sports/foobillard/foobillard-3.0a.ebuild,v 1.13 2010/03/08 22:17:34 mr_bones_ Exp $

EAPI=2
inherit eutils autotools games

DESCRIPTION="8ball, 9ball, snooker and carambol game"
HOMEPAGE="http://foobillard.sourceforge.net/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE="sdl"

RDEPEND="x11-libs/libXaw
	x11-libs/libXi
	virtual/opengl
	virtual/glu
	>=media-libs/freetype-2.0.9
	media-libs/libpng
	sdl? ( media-libs/libsdl )
	!sdl? ( virtual/glut )"
DEPEND="${RDEPEND}
	app-admin/eselect-opengl"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-no_nvidia.patch \
		"${FILESDIR}"/${P}-fbsd.patch \
		"${FILESDIR}"/${P}-as-needed.patch

	eautoreconf
}

src_configure() {
	local myconf
	[[ "$(eselect opengl show)" == 'nvidia' ]] \
		&& myconf='--enable-nvidia=yes' \
		|| myconf='--enable-nvidia=no'

	egamesconf \
		--enable-sound \
		$(use_enable sdl SDL) \
		$(use_enable !sdl glut) \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README README.FONTS
	doman foobillard.6
	newicon data/full_symbol.png foobillard.png
	make_desktop_entry foobillard Foobillard
	prepgamesdirs
}
