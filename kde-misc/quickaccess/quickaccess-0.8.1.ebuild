# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/quickaccess/quickaccess-0.8.1.ebuild,v 1.1 2010/05/11 16:19:11 spatz Exp $

EAPI="2"

inherit kde4-base

MY_PN="plasma-widget-${PN}"
MY_P="${MY_PN}_${PV}"

DESCRIPTION="KDE4 plasmoid. Designed for the panel, provides quick access to the most used folders"
HOMEPAGE="http://kde-look.org/content/show.php/QuickAccess+(maintenance+fork)?content=101968"
SRC_URI="http://kde-look.org/CONTENT/content-files/101968-${MY_P}.orig.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="debug"

RDEPEND="
	!kde-plasmoids/quickaccess
	>=kde-base/plasma-workspace-${KDE_MINIMAL}
"

S="${WORKDIR}/${MY_PN}-${PV}"
