# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/gtklife/gtklife-5.1.ebuild,v 1.4 2008/04/08 01:41:26 mr_bones_ Exp $

inherit eutils games

DESCRIPTION="A Conway's Life simulator for Unix"
HOMEPAGE="http://ironphoenix.org/tril/gtklife/"
SRC_URI="http://ironphoenix.org/tril/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
	egamesconf \
		--with-gtk2 \
		--with-docdir=/usr/share/doc/${PF}/html \
		|| die
	emake || die "emake failed"
}

src_install() {
	dogamesbin ${PN} || die "dogamesbin failed"

	insinto "${GAMES_DATADIR}"/${PN}
	doins -r graphics patterns || die "doins failed"

	newicon icon_48x48.png ${PN}.png
	make_desktop_entry ${PN} GtkLife

	dohtml doc/*
	dodoc AUTHORS README NEWS
	prepgamesdirs
}
