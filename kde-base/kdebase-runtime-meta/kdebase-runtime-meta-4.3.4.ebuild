# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdebase-runtime-meta/kdebase-runtime-meta-4.3.4.ebuild,v 1.1 2009/12/01 10:18:29 wired Exp $

EAPI="2"
inherit kde4-functions

DESCRIPTION="Merge this to pull in all kdebase-runtime-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="4.3"
KEYWORDS="~amd64 ~x86"
IUSE="kdeprefix +semantic-desktop"

RDEPEND="
	$(add_kdebase_dep drkonqi)
	$(add_kdebase_dep kcmshell)
	$(add_kdebase_dep kcontrol)
	$(add_kdebase_dep kdebase-data)
	$(add_kdebase_dep kdebase-desktoptheme)
	$(add_kdebase_dep kdebase-kioslaves)
	$(add_kdebase_dep kdebase-menu)
	$(add_kdebase_dep kdebase-menu-icons)
	$(add_kdebase_dep kdebugdialog)
	$(add_kdebase_dep kdesu)
	$(add_kdebase_dep keditfiletype)
	$(add_kdebase_dep kfile)
	$(add_kdebase_dep kglobalaccel)
	$(add_kdebase_dep khelpcenter)
	$(add_kdebase_dep kiconfinder)
	$(add_kdebase_dep kioclient)
	$(add_kdebase_dep kmimetypefinder)
	$(add_kdebase_dep knetattach)
	$(add_kdebase_dep knewstuff)
	$(add_kdebase_dep kpasswdserver)
	$(add_kdebase_dep kquitapp)
	$(add_kdebase_dep kstart)
	$(add_kdebase_dep kstyles)
	$(add_kdebase_dep ktimezoned)
	$(add_kdebase_dep ktraderclient)
	$(add_kdebase_dep kuiserver)
	$(add_kdebase_dep kurifilter-plugins)
	$(add_kdebase_dep kwalletd)
	$(add_kdebase_dep plasma-runtime)
	$(add_kdebase_dep renamedlg-plugins)
	$(add_kdebase_dep solid-hardware)
	$(add_kdebase_dep solidautoeject)
	$(add_kdebase_dep soliduiserver)
	semantic-desktop? ( $(add_kdebase_dep nepomuk) )
	$(block_other_slots)
"
