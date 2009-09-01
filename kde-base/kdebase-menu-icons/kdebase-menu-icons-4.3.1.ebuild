# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdebase-menu-icons/kdebase-menu-icons-4.3.1.ebuild,v 1.1 2009/09/01 15:05:50 tampakrap Exp $

EAPI="2"

KMNAME="kdebase-runtime"
KMMODULE="menu"
inherit kde4-meta

DESCRIPTION="KDE menu icons"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE=""

RDEPEND="
	!kdeprefix? ( !kde-base/kde-menu-icons[-kdeprefix] )
	kdeprefix? ( !kde-base/kde-menu-icons:${SLOT} )
"
