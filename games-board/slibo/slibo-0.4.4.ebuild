# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/slibo/slibo-0.4.4.ebuild,v 1.12 2007/03/12 13:53:42 genone Exp $

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

PATCHES="${FILESDIR}/${PV}-gcc34.patch ${FILESDIR}/${P}-gcc41.patch"

src_install() {
	kde_src_install
	# whack empty doc files (bug #137114)
	rm -f "${D}"/usr/share/doc/${PF}/{README.gz,TODO.gz}
}

pkg_postinst() {
	elog "If you updated from an older version, please do a"
	elog "    rm ~/.kde/share/apps/slibo/sliboui.rc"
	elog "to get rid of old configuration files, otherwise"
	elog "new menu items etc. will not appear"
}
