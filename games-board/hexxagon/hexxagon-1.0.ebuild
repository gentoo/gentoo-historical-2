# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/hexxagon/hexxagon-1.0.ebuild,v 1.14 2010/01/01 03:37:49 sping Exp $

EAPI=2
inherit eutils games

DESCRIPTION="clone of the original DOS game"
HOMEPAGE="http://www.nesqi.se/"
SRC_URI="http://www.nesqi.se/hexxagon/download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND=">=dev-cpp/glibmm-2.4
	>=dev-cpp/gtkmm-2.4
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc44.patch
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	newicon images/board_N_2.xpm ${PN}.xpm
	make_desktop_entry ${PN} Hexxagon ${PN}
	dodoc README
	prepgamesdirs
}
