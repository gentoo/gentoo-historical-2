# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdepim-meta/kdepim-meta-4.3.3.ebuild,v 1.7 2010/01/19 02:47:17 jer Exp $

EAPI="2"
inherit kde4-functions

DESCRIPTION="kdepim - merge this to pull in all kdepim-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="4.3"
KEYWORDS="~alpha amd64 hppa ~ia64 ppc ppc64 ~sparc x86"
IUSE="aqua kdeprefix"

RDEPEND="
	$(add_kdebase_dep akonadi)
	$(add_kdebase_dep akregator)
	$(add_kdebase_dep kabcclient)
	$(add_kdebase_dep kaddressbook)
	$(add_kdebase_dep kalarm)
	$(add_kdebase_dep kdepim-icons)
	$(add_kdebase_dep kdepim-kresources)
	$(add_kdebase_dep kdepim-strigi-analyzer)
	$(add_kdebase_dep kdepim-wizards)
	$(add_kdebase_dep kjots)
	$(add_kdebase_dep kleopatra)
	$(add_kdebase_dep kmail)
	$(add_kdebase_dep kmailcvt)
	$(add_kdebase_dep knode)
	$(add_kdebase_dep knotes)
	$(add_kdebase_dep konsolekalendar)
	$(add_kdebase_dep kontact)
	$(add_kdebase_dep kontact-specialdates)
	$(add_kdebase_dep kontactinterfaces)
	$(add_kdebase_dep korganizer)
	$(add_kdebase_dep kpilot)
	$(add_kdebase_dep ktimetracker)
	$(add_kdebase_dep libkdepim)
	$(add_kdebase_dep libkleo)
	$(add_kdebase_dep libkpgp)
	$(add_kdebase_dep libksieve)
	$(add_kdebase_dep mimelib)
	$(block_other_slots)
"
