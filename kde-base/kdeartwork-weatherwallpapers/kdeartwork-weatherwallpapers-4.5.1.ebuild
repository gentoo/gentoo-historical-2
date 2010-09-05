# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeartwork-weatherwallpapers/kdeartwork-weatherwallpapers-4.5.1.ebuild,v 1.1 2010/09/05 23:52:01 tampakrap Exp $

EAPI="3"

KMNAME="kdeartwork"
KMMODULE="WeatherWallpapers"
inherit kde4-meta

DESCRIPTION="Weather aware wallpapers. Changes with weather outside."
KEYWORDS=""
IUSE=""

RDEPEND="
	$(add_kdebase_dep kdeartwork-wallpapers)
"
