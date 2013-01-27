# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeadmin-meta/kdeadmin-meta-4.9.5.ebuild,v 1.2 2013/01/27 11:52:46 ago Exp $

EAPI=4
inherit kde4-meta-pkg

DESCRIPTION="KDE administration tools - merge this to pull in all kdeadmin-derived packages"
KEYWORDS="amd64 ~arm ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="cups"

RDEPEND="
	$(add_kdebase_dep kcron)
	$(add_kdebase_dep ksystemlog)
	$(add_kdebase_dep kuser)
	cups? ( $(add_kdebase_dep system-config-printer-kde) )
"
