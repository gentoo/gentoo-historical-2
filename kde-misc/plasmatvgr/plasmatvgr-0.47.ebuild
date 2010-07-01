# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/plasmatvgr/plasmatvgr-0.47.ebuild,v 1.1 2010/07/01 14:16:27 hwoarang Exp $

EAPI="2"

inherit kde4-base versionator

MY_PV=$(replace_version_separator . '')
MY_P=${PN}${MY_PV}

DESCRIPTION="KDE4 plasmoid. Shows greek TV program."
HOMEPAGE="http://www.kde-look.org/content/show.php/plasmatvgr?content=75728"
SRC_URI="http://www.kde-look.org/CONTENT/content-files/75728-${MY_P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="debug"

RDEPEND=">=kde-base/plasma-workspace-${KDE_MINIMAL}"

S="${WORKDIR}/${PN}"
