# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/media-libs/libswf/libswf-0.99.ebuild,v 1.5 2002/08/14 13:08:10 murphy Exp $

S=${WORKDIR}/dist
DESCRIPTION="A library for flash movies"
SRC_URI="http://reality.sgi.com/grafica/flash/dist.99.linux.tar.Z"
HOMEPAGE="ftp://ftp.sgi.com/sgi/graphics/grafica/flash/index.html"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 sparc sparc64"

DEPEND="virtual/glibc
	app-arch/unzip"

src_unpack() {

	unpack ${A}
	tar xf dist.99.linux.tar
}

src_install () {

	dolib.a libswf.a
	dobin bin/*
	insinto /usr/include
	doins swf.h
	insinto /usr/share/swf/fonts
	doins fonts/*
	insinto /usr/share/swf/psfonts
	doins psfonts/*
	dohtml *.html
}
