# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdebase-wallpapers/kdebase-wallpapers-4.3.1.ebuild,v 1.5 2009/10/18 13:56:10 maekke Exp $

EAPI="2"

KMNAME="kdebase-workspace"
KMMODULE="wallpapers"
inherit kde4-meta

DESCRIPTION="KDE wallpapers"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ~ppc64 x86"
IUSE=""

RDEPEND="
	!kdeprefix? ( !kde-base/kde-wallpapers[-kdeprefix] )
	kdeprefix? ( !kde-base/kde-wallpapers:${SLOT} )
"
