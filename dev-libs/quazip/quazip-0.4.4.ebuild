# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/quazip/quazip-0.4.4.ebuild,v 1.4 2012/04/03 21:01:41 jer Exp $

EAPI=4

inherit cmake-utils

DESCRIPTION="A simple C++ wrapper over Gilles Vollant's ZIP/UNZIP package"
HOMEPAGE="http://quazip.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm hppa ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	sys-libs/zlib
	x11-libs/qt-core:4"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${P}

DOCS="NEWS README.txt"

PATCHES=( "${FILESDIR}"/${P}-zlib.patch )
