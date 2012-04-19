# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeadmin-meta/kdeadmin-meta-4.8.1.ebuild,v 1.3 2012/04/19 04:12:18 maekke Exp $

EAPI=4
inherit kde4-meta-pkg

DESCRIPTION="KDE administration tools - merge this to pull in all kdeadmin-derived packages"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="cups"

RDEPEND="
	$(add_kdebase_dep kcron)
	$(add_kdebase_dep ksystemlog)
	$(add_kdebase_dep kuser)
	cups? ( $(add_kdebase_dep system-config-printer-kde) )
"
