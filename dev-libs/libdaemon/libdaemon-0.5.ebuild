# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libdaemon/libdaemon-0.5.ebuild,v 1.6 2005/01/25 11:57:52 ka0ttic Exp $

DESCRIPTION="Simple library for creating daemon processes in C"
HOMEPAGE="http://0pointer.de/lennart/projects/libdaemon/"
SRC_URI="http://0pointer.de/lennart/projects/libdaemon/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc ~amd64"
IUSE="doc"
DEPEND="doc? ( app-doc/doxygen net-www/lynx )"

src_compile() {
	local myconf

	use doc \
		&& myconf="${myconf} --enable-doxygen --enable-lynx" \
		|| myconf="${myconf} --disable-doxygen --disable-lynx"

	econf ${myconf} || die
	emake || die
}

src_install() {
	einstall || die

	if use doc; then
		ln -sf doc/reference/html reference
		dohtml -r doc/README.html reference
		doman doc/reference/man/man*/*
	fi
}
