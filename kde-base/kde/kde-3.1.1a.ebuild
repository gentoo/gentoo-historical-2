# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kde/kde-3.1.1a.ebuild,v 1.3 2003/06/22 19:38:46 caleb Exp $

IUSE=""
KEYWORDS="x86 ppc sparc ~alpha"
DESCRIPTION="KDE 3.1 - merge this to pull in all non-developer kde-base/* packages"
HOMEPAGE="http://www.kde.org/"
# removed: kdebindings, kdesdk, kdoc since these are developer-only packages
RDEPEND="`echo ~kde-base/kde{libs,base,graphics}-${PV}`
	`echo ~kde-base/kde{addons,admin,artwork,edu,games,multimedia,pim,toys,utils}-3.1.1`"
LICENSE="GPL-2"

SLOT="3.1"
