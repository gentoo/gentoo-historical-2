# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-frameworks/kglobalaccel/kglobalaccel-5.7.0.ebuild,v 1.1 2015/02/14 22:09:55 johu Exp $

EAPI=5

VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Framework to handle global shortcuts"
KEYWORDS=" ~amd64 ~x86"
LICENSE="LGPL-2+"
IUSE="nls X"

RDEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kwindowsystem)
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	X? (
		dev-qt/qtx11extras:5
		x11-libs/libxcb
		x11-libs/xcb-util-keysyms
	)
	!<kde-plasma/plasma-workspace-5.2.0-r2
"
DEPEND="${RDEPEND}
	nls? ( dev-qt/linguist-tools:5 )
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package X X11)
		$(cmake-utils_use_find_package X XCB)
	)

	kde5_src_configure
}
