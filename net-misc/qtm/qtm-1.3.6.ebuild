# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/qtm/qtm-1.3.6.ebuild,v 1.3 2012/04/06 10:59:08 ago Exp $

EAPI="2"

inherit cmake-utils

DESCRIPTION="Qt4 blogging client"
HOMEPAGE="http://qtm.blogistan.co.uk"
SRC_URI="mirror://sourceforge/catkin/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="dbus debug ssl"
RESTRICT="strip"

RDEPEND="x11-libs/qt-gui:4
	dbus? ( x11-libs/qt-dbus:4 )
	x11-proto/xproto
	dev-lang/perl
	virtual/perl-Digest-MD5"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

CMAKE_IN_SOURCE_BUILD="1"

DOCS="Changelog README"

src_configure() {
	mycmakeargs="-DDONT_USE_PTE=FALSE -DINSTALL_MARKDOWN=TRUE
	$(cmake-utils_use debug QDEBUG)
	$(cmake-utils_use ssl)"
	! use dbus && mycmakeargs="${mycmakeargs} -DDONT_USE_DBUS=TRUE"
	cmake-utils_src_configure
}
