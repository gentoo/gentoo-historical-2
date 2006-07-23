# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/goggles/goggles-0.7.10.ebuild,v 1.4 2006/07/23 14:14:47 dertobi123 Exp $

inherit eutils toolchain-funcs

DESCRIPTION="User-friendly frontend for the Ogle DVD Player"
HOMEPAGE="http://www.fifthplanet.net/goggles.html"
SRC_URI="http://www.fifthplanet.net/files/goggles-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE="doc"

DEPEND=">=x11-libs/fox-1.2
	>=media-video/ogle-0.9.2
	media-libs/libpng"

src_unpack() {
	unpack ${A}

	cd ${S}
	sed -i \
		-e "/^export CC=/s:=.*:=\"$(t-getCC)\":" \
		-e "/^export CXX=/s:=.*:=\"$(tc-getCXX)\":" \
		-e "/^export CFLAGS=/s:=.*:=\"${CFLAGS}\":" \
		-e "/^export CXXFLAGS=/s:=.*:=\"${CXXFLAGS}\":" \
		build/config.linux
}

src_compile() {
	./gb || die "build failed"

	# we do it now manually, to avoid calling 'gb install'
	sed "s|@prefix@|/${D}${DESTTREE}|" scripts/goggles.in > scripts/goggles
}

src_install() {
	dobin ${S}/scripts/goggles
	dobin ${S}/src/ogle_gui_goggles

	if use doc; then
		dodoc ${S}/desktop/goggles_manual.pdf
	fi

	insinto /usr/share/applications
	doins ${S}/desktop/${PN}.desktop

	insinto /usr/share/pixmaps
	newins ${S}/icons/goggleslogosmall_png.png goggles.png
}
