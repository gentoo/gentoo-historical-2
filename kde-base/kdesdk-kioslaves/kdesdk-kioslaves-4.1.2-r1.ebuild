# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdesdk-kioslaves/kdesdk-kioslaves-4.1.2-r1.ebuild,v 1.1 2008/10/30 12:24:53 scarabeus Exp $

EAPI="2"

KMNAME="kdesdk"
KMMODULE="kioslave"
inherit kde4-meta

DESCRIPTION="kioslaves from kdesdk package: the subversion kioslave"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="dev-libs/apr
	dev-util/subversion"

src_configure() {
	mycmakeargs="${mycmakeargs} -DAPRCONFIG_EXECUTABLE=/usr/bin/apr-1-config"
	kde4-meta_src_configure
}
# warning when there is kdesvn for kde4 it will collide with this package
