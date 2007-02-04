# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/taglib/taglib-1.4-r1.ebuild,v 1.7 2007/02/04 06:50:11 beandog Exp $

inherit libtool eutils

DESCRIPTION="A library for reading and editing audio meta data"
HOMEPAGE="http://developer.kde.org/~wheeler/taglib.html"
SRC_URI="http://developer.kde.org/~wheeler/files/src/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~alpha amd64 hppa ~ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="debug"

DEPEND="sys-libs/zlib"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-dirtypointer.patch"

	elibtoolize
}

src_compile() {
	econf $(use_enable debug) || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog README TODO
}
