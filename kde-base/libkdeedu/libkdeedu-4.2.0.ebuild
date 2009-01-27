# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/libkdeedu/libkdeedu-4.2.0.ebuild,v 1.1 2009/01/27 18:08:48 alexxy Exp $

EAPI="2"

KMNAME="kdeedu"
inherit kde4-meta

DESCRIPTION="Common library for KDE educational apps"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

src_install() {
	kde4-meta_src_install
	# This is installed by kde-base/marble
	rm "${D}"/"${KDEDIR}"/share/apps/cmake/modules/FindMarbleWidget.cmake
}
