# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libdaemon/libdaemon-0.3.ebuild,v 1.2 2004/02/22 11:26:29 dholm Exp $

DESCRIPTION="Simple library for creating daemon processes in C"
HOMEPAGE="http://0pointer.de/lennart/projects/libdaemon/"
SRC_URI="${HOMEPAGE}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc"
IUSE="doc"
DEPEND="doc? ( app-doc/doxygen net-www/lynx )"
S=${WORKDIR}/${P}

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
