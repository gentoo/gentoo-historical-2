# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeartwork-meta/kdeartwork-meta-4.6.2.ebuild,v 1.2 2011/05/09 08:48:48 tomka Exp $

EAPI=3
inherit kde4-meta-pkg

DESCRIPTION="kdeartwork - merge this to pull in all kdeartwork-derived packages"
KEYWORDS="~amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	$(add_kdebase_dep kdeartwork-colorschemes)
	$(add_kdebase_dep kdeartwork-desktopthemes)
	$(add_kdebase_dep kdeartwork-emoticons)
	$(add_kdebase_dep kdeartwork-iconthemes)
	$(add_kdebase_dep kdeartwork-kscreensaver)
	$(add_kdebase_dep kdeartwork-sounds)
	$(add_kdebase_dep kdeartwork-styles)
	$(add_kdebase_dep kdeartwork-wallpapers)
	$(add_kdebase_dep kdeartwork-weatherwallpapers)
"
