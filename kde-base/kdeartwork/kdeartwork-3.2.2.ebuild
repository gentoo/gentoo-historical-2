# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeartwork/kdeartwork-3.2.2.ebuild,v 1.3 2004/05/12 15:37:51 caleb Exp $

inherit kde-dist

DESCRIPTION="KDE artwork package"

KEYWORDS="x86 ~ppc ~sparc ~alpha ~hppa ~amd64 ~ia64 ~mips"
IUSE="opengl"

DEPEND="opengl? ( virtual/opengl )
	~kde-base/kdebase-${PV}"

src_compile() {
	myconf="$myconf --with-dpms `use_with opengl gl`"
	kde_src_compile
}
