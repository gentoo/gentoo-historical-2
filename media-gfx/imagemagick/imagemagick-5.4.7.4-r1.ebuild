# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/imagemagick/imagemagick-5.4.7.4-r1.ebuild,v 1.11 2004/04/26 02:27:18 agriffis Exp $

IUSE="perl X cups xml2 lcms"

inherit libtool perl-module eutils

MY_PN=ImageMagick
MY_P=${MY_PN}-${PV%.*}-${PV#*.*.*.}
S=${WORKDIR}/${MY_PN}-${PV%.*}
DESCRIPTION="A collection of tools and libraries for many image formats"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
HOMEPAGE="http://www.imagemagick.org/"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ppc sparc ~alpha ~mips ~hppa"

DEPEND=">=sys-apps/sed-4
	media-libs/libpng
	>=app-arch/bzip2-1
	>=sys-libs/zlib-1.1.3
	>=media-libs/freetype-2.0
	>=media-libs/jpeg-6b
	>=media-libs/tiff-3.5.5
	X? ( virtual/x11
		>=app-text/dgs-0.5.9.1 )
	cups?   ( virtual/ghostscript )
	lcms? ( >=media-libs/lcms-1.06 )
	perl? ( >=dev-lang/perl-5 )
	xml2? ( >=dev-libs/libxml2-2.4.10 )"

src_compile() {
	elibtoolize

	local myconf=""
	use perl || myconf="--without-perl"
	use lcms || myconf="${myconf} --without-lcms"
	use xml2 || myconf="${myconf} --without-xml"
	use X    || myconf="${myconf} --with-x=no"

	# Netscape is still used ?  More people should have Mozilla
	sed -i 's:netscape:mozilla:g' configure

	#patch to allow building by perl
	epatch ${FILESDIR}/perlpatch.diff

	econf \
		--enable-shared \
		--enable-static \
		--enable-lzw \
		--with-ttf \
		--with-fpx \
		--without-gslib \
		--without-hdf \
		--with-jbig \
		--with-wmf \
		--with-threads \
		${myconf} || die "bad configure"
	emake || die "compile problem"

	# More perl stuff
	cd PerlMagick
	make clean
	perl-module_src_prep
	cd ..
}

src_install() {
	myinst="prefix=${D}/usr PREFIX=${D}/usr"
	myinst="${myinst} MagickSharePath=${D}/usr/share/ImageMagick/"
	myinst="${myinst} pkgdocdir=${D}/usr/share/doc/${PF}/html/"
	myinst="${myinst} mandir=${D}/usr/share/man"
	myinst="${myinst} datadir=${D}/usr/share"

	mydoc="*.txt"
	perl-module_src_install

	rm -f ${D}/usr/share/ImageMagick/*.txt
}
