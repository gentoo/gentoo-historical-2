# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kcachegrind/kcachegrind-4.4.4.ebuild,v 1.1 2010/06/06 14:41:37 scarabeus Exp $

EAPI="3"

KMNAME="kdesdk"
inherit kde4-meta

DESCRIPTION="KDE Frontend for Cachegrind"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug +handbook"

RDEPEND="
	media-gfx/graphviz
"
