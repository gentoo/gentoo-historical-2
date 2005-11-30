# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/slibo/slibo-0.4.4.ebuild,v 1.1.1.1 2005/11/30 10:09:59 chriswhite Exp $

inherit eutils kde

DESCRIPTION="A comfortable replacement for the xboard chess interface"
HOMEPAGE="http://slibo.sourceforge.net/"
SRC_URI="mirror://sourceforge/slibo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="=dev-db/sqlite-2*"
need-kde 3

src_unpack() {
	kde_src_unpack
	cd "${S}"
	epatch "${FILESDIR}/${PV}-gcc34.patch"
}

pkg_postinst() {
	einfo "If you updated from an older version, please do a"
	einfo "    rm ~/.kde/share/apps/slibo/sliboui.rc"
	einfo "to get rid of old configuration files, otherwise"
	einfo "new menu items etc. will not appear"
}
