# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/quazip/quazip-0.4.3-r1.ebuild,v 1.6 2011/11/04 12:25:42 naota Exp $

EAPI=4

inherit eutils multilib cmake-utils

DESCRIPTION="A simple C++ wrapper over Gilles Vollant's ZIP/UNZIP package"
HOMEPAGE="http://quazip.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="sys-libs/zlib
	x11-libs/qt-gui:4"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${P}

DOCS="NEWS README.txt"

src_prepare() {
	# Support zlib-1.2.5.1-r1 (bug #383309)
	epatch "${FILESDIR}"/${P}-zlib.patch
}
