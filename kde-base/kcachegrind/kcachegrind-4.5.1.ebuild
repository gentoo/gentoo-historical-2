# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kcachegrind/kcachegrind-4.5.1.ebuild,v 1.1 2010/09/05 23:30:10 tampakrap Exp $

EAPI="3"

KDE_HANDBOOK=1
KMNAME="kdesdk"
inherit kde4-meta

DESCRIPTION="KDE Frontend for Cachegrind"
KEYWORDS=""
IUSE="debug"

RDEPEND="
	media-gfx/graphviz
"
