# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/gnono/gnono-0.0.3.ebuild,v 1.5 2004/11/11 12:50:54 wolf31o2 Exp $

inherit games

DESCRIPTION="rewrite of Windows card game WUNO"
HOMEPAGE="http://www.paw.co.za/projects/gnono/"
SRC_URI="ftp://ftp.paw.co.za/pub/PAW/sources/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64"
IUSE="nls"

DEPEND="gnome-base/gnome-libs
	=dev-libs/glib-1.2*
	virtual/x11
	media-libs/gdk-pixbuf
	=x11-libs/gtk+-1.2*"

src_compile() {
	egamesconf $(use_enable nls) || die
	emake || die "emake failed"
}

src_install() {
	einstall || die
	prepgamesdirs
}
