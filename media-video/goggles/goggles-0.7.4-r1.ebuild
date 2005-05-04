# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/goggles/goggles-0.7.4-r1.ebuild,v 1.2 2005/05/04 18:05:36 luckyduck Exp $

inherit eutils gcc

DESCRIPTION="User-friendly frontend for the Ogle DVD Player"
HOMEPAGE="http://www.fifthplanet.net/goggles.html"
SRC_URI="http://www.fifthplanet.net/files/goggles-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc amd64"
IUSE="doc"

DEPEND=">=x11-libs/fox-1.2
	>=media-video/ogle-0.9.2
	media-libs/libpng"

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${P}-gentoo.patch

	sed -i \
		-e "/^export CC=/s:=.*:=\"$(gcc-getCC)\":" \
		-e "/^export CXX=/s:=.*:=\"$(gcc-getCXX)\":" \
		-e "/^export CFLAGS=/s:=.*:=\"${CFLAGS}\":" \
		-e "/^export CXXFLAGS=/s:=.*:=\"${CXXFLAGS}\":" \
		build/config.linux
}

src_compile() {
	./gb || die "build failed"
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
