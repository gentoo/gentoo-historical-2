# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/grhino/grhino-0.16.0.ebuild,v 1.1 2007/01/08 07:08:44 tupone Exp $

inherit eutils games

DESCRIPTION="Reversi game for GNOME, supporting the Go/Game Text Protocol"
HOMEPAGE="http://rhino.sourceforge.net/"
SRC_URI="mirror://sourceforge/rhino/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="gnome gtp"

DEPEND="gnome? ( =gnome-base/libgnomeui-2* )"

pkg_setup() {
	if ! ( use gnome || use gtp ); then
		die "Aborting build. You you have to specify gnome or gtp use flags"
	fi
	games_pkg_setup
}

src_compile() {
	egamesconf \
		$(use_enable gnome) \
		$(use_enable gtp) \
		|| die "egamesconf failed"
	emake || die "emake failed"
}

src_install() {
	use gnome && dogamesbin ${PN} \
		|| die "installing the binary failed"
	use gtp && dogamesbin gtp-rhino \
		|| die "installing the binary failed"
	make install DESTDIR=${D}

	dodoc ChangeLog NEWS README TODO

	doicon ${PN}.png
	make_desktop_entry ${PN} "GRhino" ${PN}.png

	prepgamesdirs
}
