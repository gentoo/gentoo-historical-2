# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/oxygen-icons/oxygen-icons-4.6.2.ebuild,v 1.4 2011/06/01 19:19:31 ranger Exp $

EAPI=3

if [[ ${PV} = *9999* ]]; then
	KMNAME="kdesupport"
else
	KMNAME="oxygen-icons"
fi
KDE_REQUIRED="never"
inherit kde4-base

DESCRIPTION="Oxygen SVG icon theme."
HOMEPAGE="http://www.oxygen-icons.org/"
SRC_URI="http://dev.gentoo.org/~scarabeus/${P}.tar.xz"
#SRC_URI="mirror://kde/unstable/${PV}/src/${P}.tar.bz2"

LICENSE="LGPL-3"
KEYWORDS="amd64 ~arm ppc ~ppc64 x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="aqua"

# Block conflicting packages
add_blocker kdebase-data '<4.2.67'
add_blocker kdepim-icons 4.2.89
add_blocker step 4.2.98
add_blocker kmail '<4.3.2'
