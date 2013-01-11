# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libechonest/libechonest-2.0.2.ebuild,v 1.1 2013/01/11 14:00:16 ssuominen Exp $

EAPI=5
inherit cmake-utils

DESCRIPTION="A library for communicating with The Echo Nest"
HOMEPAGE="http://projects.kde.org/projects/playground/libs/libechonest"
SRC_URI="http://files.lfranchi.com/${P}.tar.bz2
	http://pwsp.cleinias.com/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="test" # Networking required

RDEPEND=">=dev-libs/qjson-0.5
	x11-libs/qt-core:4"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-libs/qt-test:4"

PATCHES=( "${FILESDIR}"/${PN}-2.0.1-Werror.patch )

DOCS=( AUTHORS README TODO )
