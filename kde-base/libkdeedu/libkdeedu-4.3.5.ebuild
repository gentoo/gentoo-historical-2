# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/libkdeedu/libkdeedu-4.3.5.ebuild,v 1.3 2010/03/11 18:33:55 ranger Exp $

EAPI="2"

KMNAME="kdeedu"
inherit kde4-meta

DESCRIPTION="Common library for KDE educational apps"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="debug"

# 4 of 4 tests fail. Last checked for 4.2.87
RESTRICT=test

src_install() {
	kde4-meta_src_install
	# This is installed by kde-base/marble
	rm "${ED}"/${KDEDIR}/share/apps/cmake/modules/FindMarbleWidget.cmake
}
