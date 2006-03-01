# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/krecipes/krecipes-0.9.1.ebuild,v 1.5 2006/03/01 00:10:20 caleb Exp $

inherit kde

DESCRIPTION="A KDE Recipe Tool"
HOMEPAGE="http://krecipes.sourceforge.net"
SRC_URI="mirror://sourceforge/krecipes/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ppc sparc x86"
IUSE="mysql postgres sqlite"

DEPEND="sqlite? ( dev-db/sqlite )
		!sqlite? ( !mysql? ( !postgres? ( dev-db/sqlite ) ) )"
RDEPEND="${DEPEND}
	mysql? ( dev-db/mysql )
	postgres? ( dev-db/postgresql )"

need-kde 3

src_compile() {
	if ! use sqlite && ! use mysql && ! use postgres; then
		myconf="--with-sqlite"
	else
		myconf="$(use_with sqlite) $(use_with mysql) $(use_with postgres postgresql)"
	fi

	kde_src_compile
}
