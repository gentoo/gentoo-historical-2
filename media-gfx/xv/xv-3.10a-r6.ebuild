# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/xv/xv-3.10a-r6.ebuild,v 1.6 2004/02/17 23:02:05 agriffis Exp $

inherit ccc flag-o-matic eutils

DESCRIPTION="An interactive image manipulation program for X which can deal with a wide variety of image formats"
HOMEPAGE="http://www.trilon.com/xv/index.html"
SRC_URI="ftp://ftp.cis.upenn.edu/pub/xv/${P}.tar.gz"

LICENSE="xv"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc alpha ~amd64 mips hppa ia64"
IUSE="jpeg tiff png"

DEPEND="virtual/x11
	jpeg? ( >=media-libs/jpeg-6b )
	tiff? ( >=media-libs/tiff-3.5 )
	png? ( >=media-libs/libpng-1.2 >=sys-libs/zlib-1.1.4 )"

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${P}-enhanced-Nu.patch || die
	epatch ${FILESDIR}/${P}-gentoo-Nu.patch || die
	[ `use ppc` ] && epatch ${FILESDIR}/${P}-ppc.patch
}

src_compile() {
	[ -z `use jpeg` ] \
		&& sed -i -e "s:JPEGLIB = -ljpeg:JPEGLIB =:" Makefile \
		|| append-flags -DDOJPEG
	[ -z `use png` ] \
		&& sed -i -e "s:PNGLIB = -lpng:PNGLIB =:" Makefile \
		&& sed -i -e "s:ZLIBLIB = -lz:ZLIBLIB =:" Makefile \
		|| append-flags -DDOPNG
	[ -z `use tiff` ] \
		&& sed -i -e "s:TIFFLIB = -ltiff:TIFFLIB =:" Makefile \
		|| append-flags -DDOTIFF
	sed -i "s:CCOPTS = -O:CCOPTS = ${CFLAGS}:" Makefile
	sed -i "s:COPTS=\t-O:COPTS= ${CFLAGS}:" tiff/Makefile
	is-ccc && replace-cc-hardcode
	make || die
}

src_install() {
	dodir /usr/bin
	dodir /usr/share/man/man1

	# LIBDIR is where xv installs xvdocs.ps and we dodoc it below
	make \
		DESTDIR=${D} \
		BINDIR=${D}/usr/bin \
		MANDIR=${D}/usr/share/man/man1 \
		LIBDIR=/dev/null \
		install || die

	dodoc README INSTALL CHANGELOG BUGS IDEAS docs/*.ps docs/*.doc
}
