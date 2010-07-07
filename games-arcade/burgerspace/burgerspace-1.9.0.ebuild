# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/burgerspace/burgerspace-1.9.0.ebuild,v 1.4 2010/07/07 12:32:29 fauli Exp $

EAPI=2
inherit autotools games

DESCRIPTION="Clone of the 1982 BurgerTime video game by Data East"
HOMEPAGE="http://perso.b2b2c.ca/sarrazip/dev/burgerspace.html"
SRC_URI="http://perso.b2b2c.ca/sarrazip/dev/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~x86-fbsd"
IUSE="network"
RESTRICT="test"  # doesn't really test anything

RDEPEND=">=dev-games/flatzebra-0.1.5"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	sed -i \
		-e "/^pkgsounddir/ s:sounds.*:\$(PACKAGE)/sounds:" \
		-e "/^desktopentrydir/ s:=.*:=/usr/share/applications:" \
		-e "/^pixmapdir/ s:=.*:=/usr/share/pixmaps:" \
		src/Makefile.am \
		|| die "sed failed"
	eautoreconf
}

src_compile() {
	egamesconf \
		$(use_with network)
}

src_install() {
	emake -C src DESTDIR="${D}" install || die "emake install failed"
	doman doc/${PN}.6
	dodoc AUTHORS NEWS README THANKS
	prepgamesdirs
}
