# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/glob2/glob2-0.9.4.1.ebuild,v 1.3 2009/06/06 16:55:45 nixnut Exp $

EAPI=2
inherit eutils games

DESCRIPTION="Real Time Strategy (RTS) game involving a brave army of globs"
HOMEPAGE="http://globulation2.org/"
SRC_URI="http://dl.sv.nongnu.org/releases/glob2/0.9.4/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~hppa ppc ~x86"
IUSE=""

RDEPEND="virtual/opengl
	virtual/glu
	>=dev-libs/boost-1.34
	media-libs/libsdl[opengl]
	media-libs/sdl-net
	media-libs/sdl-ttf
	media-libs/sdl-image
	media-libs/libvorbis
	dev-libs/fribidi
	media-libs/speex"
DEPEND="${RDEPEND}
	>=dev-util/scons-1"

src_compile() {
	local sconsopts=$(echo "${MAKEOPTS}" | sed -ne "/-j/ { s/.*\(-j[0-9]\+\).*/\1/; p }")

	scons \
		${sconsopts} \
		CXXFLAGS="${CXXFLAGS}" \
		LINKFLAGS="${LDFLAGS}" \
		INSTALLDIR="${GAMES_DATADIR}"/${PN} \
		DATADIR="${GAMES_DATADIR}"/${PN} \
		|| die "scons failed again"
}

src_install() {
	dogamesbin src/${PN} || die "dogamesbin failed"
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r campaigns data maps scripts || die "doins failed"
	find "${D}/${GAMES_DATADIR}"/${PN} -name SConscript -exec rm -f {} +
	newicon data/icons/glob2-icon-48x48.png ${PN}.png
	make_desktop_entry glob2 "Globulation 2"
	dodoc README*
	prepgamesdirs
}
