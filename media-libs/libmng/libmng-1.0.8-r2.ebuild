# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libmng/libmng-1.0.8-r2.ebuild,v 1.1 2006/04/01 01:53:02 flameeyes Exp $

inherit autotools

DESCRIPTION="Multiple Image Networkgraphics lib (animated png's)"
HOMEPAGE="http://www.libmng.com/"
SRC_URI="http://download.sourceforge.net/libmng/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc-macos ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=media-libs/jpeg-6b
	>=sys-libs/zlib-1.1.4
	>=media-libs/lcms-1.0.8"

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i -e 's:\(#include\) "lcms.h":\1 <lcms/lcms.h>:' libmng_types.h
	sed -i -e 's:lcms\.h:lcms/lcms\.h:' makefiles/configure.in

	ln -s makefiles/configure.in .
	ln -s makefiles/Makefile.am .

	eautoreconf
}

src_compile() {
	econf --with-lcms || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die

	dodoc CHANGES README*
	dodoc doc/doc.readme doc/libmng.txt
	doman doc/man/*
}
