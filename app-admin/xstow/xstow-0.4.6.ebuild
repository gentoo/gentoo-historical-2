# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/xstow/xstow-0.4.6.ebuild,v 1.6 2004/06/24 21:43:08 agriffis Exp $

inherit eutils

DESCRIPTION="replacement for GNU stow with extensions"
SRC_URI="mirror://sourceforge/xstow/${P}.tar.gz"
HOMEPAGE="http://xstow.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"
IUSE="ncurses"

DEPEND="virtual/glibc
	ncurses? ( sys-libs/ncurses )"

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${P}-configure-ncurses.diff
}

src_compile() {
	econf `use_with ncurses` || die
	emake || die
}

src_install() {
	dodoc README AUTHORS NEWS README TODO ChangeLog
	make DESTDIR=${D} PACKAGE=${P} install || die
}
