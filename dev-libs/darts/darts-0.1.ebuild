# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/darts/darts-0.1.ebuild,v 1.4 2004/06/24 23:04:24 agriffis Exp $

DESCRIPTION="A C++ template library that implements Double-Array"
HOMEPAGE="http://cl.aist-nara.ac.jp/~taku-ku/software/darts/"
SRC_URI="http://cl.aist-nara.ac.jp/~taku-ku/software/darts/src/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="zlib"
DEPEND="virtual/glibc
	zlib? ( sys-libs/zlib )"

src_compile() {
	econf `use_with zlib` || die
	emake || die
}

src_install() {
	einstall || die

	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README || die
	dohtml doc/* || die
}
