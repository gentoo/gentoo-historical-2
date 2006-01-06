# Copyright 2004-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/wargus/wargus-2.1.ebuild,v 1.1 2006/01/06 13:49:24 genstef Exp $

inherit eutils games

DESCRIPTION="Warcraft II for the Stratagus game engine (Needs WC2 DOS CD)"
HOMEPAGE="http://wargus.sf.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="media-libs/libpng
	sys-libs/zlib"
RDEPEND="=games-engines/stratagus-${PV:0:3}*"

pkg_setup() {
	cdrom_get_cds data/rezdat.war
	games_pkg_setup
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch ${FILESDIR}/wargus-2.1-humanbasespell.patch \
		${FILESDIR}/wargus-2.1-ai.patch \
		${FILESDIR}/wargus-2.1-aitransporter.patch
}

src_install() {
	local dir="${GAMES_DATADIR}/stratagus/${PN}"
	dodir "${dir}"
	./build.sh -p "${CDROM_ROOT}" -o "${D}/${dir}" -v \
		|| die "Failed to extract data"
	games_make_wrapper wargus "./stratagus -d \"${dir}\"" "${GAMES_BINDIR}"
	prepgamesdirs
}
