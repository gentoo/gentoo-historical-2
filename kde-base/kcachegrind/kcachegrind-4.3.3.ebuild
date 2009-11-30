# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kcachegrind/kcachegrind-4.3.3.ebuild,v 1.3 2009/11/30 06:54:40 josejx Exp $

EAPI="2"

KMNAME="kdesdk"
inherit kde4-meta

DESCRIPTION="KDE Frontend for Cachegrind"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ppc64 ~x86"
IUSE="debug +handbook"

RDEPEND="
	media-gfx/graphviz
"
