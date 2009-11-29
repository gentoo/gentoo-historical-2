# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdebase-menu/kdebase-menu-4.3.3.ebuild,v 1.3 2009/11/29 17:39:58 armin76 Exp $

EAPI="2"

KMNAME="kdebase-runtime"
KMMODULE="kde-menu"
inherit kde4-meta

DESCRIPTION="KDE Menu query tool."
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug"

add_blocker kde-menu
