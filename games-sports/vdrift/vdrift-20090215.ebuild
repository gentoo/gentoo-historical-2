# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-sports/vdrift/vdrift-20090215.ebuild,v 1.4 2009/06/01 13:03:39 maekke Exp $

EAPI=2
inherit eutils games

MY_P=${PN}-${PV:0:4}-${PV:4:2}-${PV:6}
DESCRIPTION="A driving simulation made with drift racing in mind"
HOMEPAGE="http://vdrift.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}-src.tar.bz2"

LICENSE="GPL-2 ZLIB"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls"

RDEPEND="virtual/opengl
	virtual/glu
	media-libs/glew
	media-libs/libsdl[opengl,video]
	media-libs/openal
	media-libs/sdl-gfx
	media-libs/sdl-image[png]
	media-libs/sdl-net
	media-libs/libvorbis
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	dev-util/scons
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/${PN}-${PV:0:4}-${PV:4:2}-${PV:6:2}

src_unpack() {
	unpack ${A}
	cd "${S}"
	unpack ./bullet-2.73-sp1.tgz
}

src_prepare() {
	sed -i \
		-e "s/'-O1',\?//" \
		SConstruct \
		|| die "sed failed"
}

src_compile() {
	local sconsopts=$(echo "${MAKEOPTS}" | sed -ne "/-j/ { s/.*\(-j[0-9]\+\).*/\1/; p }")

	scons \
		${sconsopts} \
		NLS=$(use nls && echo 1 || echo 0) \
		destdir="${D}" \
		bindir="${GAMES_BINDIR}" \
		datadir="${GAMES_DATADIR}"/${PN} \
		localedir=/usr/share/locale \
		prefix= \
		use_binreloc=0 \
		release=1 \
		os_cc=1 \
		os_cxx=1 \
		os_cxxflags=1 \
		|| die "scons failed"
}

src_install() {
	dogamesbin build/vdrift || die "dogamesbin failed"
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r data/* || die "doins failed"
	newicon data/textures/icons/vdrift-64x64.png ${PN}.png
	make_desktop_entry ${PN} VDrift
	dodoc docs/*
	find "${D}" -name "SCon*" -exec rm \{\} +
	cd "${D}"
	keepdir $(find "${GAMES_DATADIR/\//}/${PN}" -type d -empty)
	prepgamesdirs
}
