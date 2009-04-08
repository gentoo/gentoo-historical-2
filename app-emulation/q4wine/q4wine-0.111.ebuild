# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/q4wine/q4wine-0.111.ebuild,v 1.3 2009/04/08 23:57:55 hwoarang Exp $

EAPI="2"
inherit cmake-utils

DESCRIPTION="Qt4 GUI for wine"
HOMEPAGE="http://sourceforge.net/projects/q4wine/"
SRC_URI="mirror://sourceforge/${PN}/${PF}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="x11-libs/qt-gui:4
	x11-libs/qt-sql:4[sqlite]
	dev-util/cmake"
RDEPEND="x11-libs/qt-gui:4
	x11-libs/qt-sql:4[sqlite]
	app-admin/sudo
	app-emulation/wine
	>=sys-apps/which-2.19
	>=media-gfx/icoutils-0.26.0"

DOCS="README"

