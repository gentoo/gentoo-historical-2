# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/imagemagick/imagemagick-5.5.6-r1.ebuild,v 1.14 2004/04/26 02:27:18 agriffis Exp $

inherit libtool flag-o-matic
replace-flags k6-3 i586
replace-flags k6-2 i586
replace-flags k6 i586

IUSE="X cups jpeg lcms mpeg png truetype tiff xml2 wmf"

MY_PN=ImageMagick

### no PV hacks needed as we don't have a patchlevel with this release
#MY_P=${MY_PN}-${PV%.*}-${PV#*.*.*.}
#MY_P2=${MY_PN}-${PV%.*}
MY_P=${MY_PN}-${PV}
MY_P2=${MY_PN}-${PV}

S=${WORKDIR}/${MY_P2}
DESCRIPTION="A collection of tools and libraries for many image formats"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"
HOMEPAGE="http://www.imagemagick.org/"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ppc sparc ~alpha ~mips hppa amd64"

DEPEND=">=sys-apps/sed-4
	media-libs/jbigkit
	>=app-arch/bzip2-1
	sys-libs/zlib
	X? ( virtual/x11
		>=app-text/dgs-0.5.9.1 )
	cups?   ( virtual/ghostscript )
	jpeg? ( >=media-libs/jpeg-6b )
	lcms? ( >=media-libs/lcms-1.06 )
	mpeg? ( media-video/mpeg2vidcodec )
	png? ( media-libs/libpng )
	tiff? ( >=media-libs/tiff-3.5.5 )
	xml2? ( >=dev-libs/libxml2-2.4.10 )
	truetype? ( =media-libs/freetype-2* )
	wmf? ( media-libs/libwmf )"

src_compile() {
	elibtoolize
	if [ "${ARCH}" = "amd64" ]
	then
		append-flags -fPIC
	fi

	local myconf=""
	use X    || myconf="${myconf} --with-x=no"
	use cups || myconf="${myconf} --without-gslib"
	use jpeg || myconf="${myconf} --without-jpeg --without-jp2"
	use lcms || myconf="${myconf} --without-lcms"
	use mpeg || myconf="${myconf} --without-mpeg2"
	use tiff || myconf="${myconf} --without-tiff"
	use xml2 || myconf="${myconf} --without-xml"
	use truetype || myconf="${myconf} --without-ttf"
	use wmf || myconf="${myconf} --without-wmf"
	# Netscape is still used ?  More people should have Mozilla
	sed -i 's:netscape:mozilla:g' configure

	#patch to allow building by perl
	epatch ${FILESDIR}/perlpatch.diff

	econf \
		--enable-shared \
		--enable-lzw \
		--with-fpx \
		--with-jbig \
		--without-hdf \
		--with-threads \
		--with-bzlib \
		${myconf} || die
		#--enable-static
		\
	emake || die "compile problem"
}

src_install() {
	make DESTDIR=${D} install
	mydoc="*.txt"

	rm -f ${D}/usr/share/ImageMagick/*.txt

	dosed "s:-I/usr/include ::" /usr/bin/Magick-config
	dosed "s:-I/usr/include ::" /usr/bin/Magick++-config

	dosym /usr/lib/libMagick-5.5.6-Q16.so.0.0.0 /usr/lib/libMagick.so.5
}
