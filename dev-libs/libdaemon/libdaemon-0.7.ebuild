# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libdaemon/libdaemon-0.7.ebuild,v 1.2 2004/12/20 22:29:09 config Exp $

DESCRIPTION="Simple library for creating daemon processes in C"
HOMEPAGE="http://0pointer.de/lennart/projects/libdaemon/"
SRC_URI="http://0pointer.de/lennart/projects/libdaemon/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE="doc"

DEPEND="doc? ( app-doc/doxygen net-www/lynx )"

src_compile() {
	local myconf="--disable-doxygen --disable-lynx"
	use doc	&& myconf="--enable-doxygen --enable-lynx"

	econf ${myconf} || die "econf failed"

	emake || die "emake failed"
	if use doc ; then
		einfo "Building documentation"
		make doxygen || die "make doxygen failed"
	fi
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	if use doc; then
		ln -sf doc/reference/html reference
		dohtml -r doc/README.html reference
		doman doc/reference/man/man*/*
	fi

	dodoc README
	docinto examples ; dodoc examples/testd.c
}
