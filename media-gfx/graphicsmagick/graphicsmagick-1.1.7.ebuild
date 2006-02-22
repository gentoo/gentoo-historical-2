# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/graphicsmagick/graphicsmagick-1.1.7.ebuild,v 1.3 2006/02/22 08:18:30 tsunam Exp $

inherit libtool flag-o-matic perl-app
replace-flags k6-3 i586
replace-flags k6-2 i586
replace-flags k6 i586

IUSE="X gs jbig jp2 jpeg lcms lzw perl png tiff truetype wmf xml2 doc"

MY_PN=GraphicsMagick
MY_P=${MY_PN}-${PV}

S=${WORKDIR}/${MY_P}
DESCRIPTION="A collection of tools and libraries for many image formats"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"
HOMEPAGE="http://www.graphicsmagick.org/"

SLOT="0"
LICENSE="as-is"
KEYWORDS="~ppc ~ppc64 ~sparc x86"

DEPEND=">=sys-apps/sed-4
	>=app-arch/bzip2-1
	sys-libs/zlib
	X? ( virtual/x11 )
	gs?   ( virtual/ghostscript )
	jbig? ( media-libs/jbigkit )
	jp2? ( media-libs/jasper )
	jpeg? ( >=media-libs/jpeg-6b )
	lcms? ( >=media-libs/lcms-1.06 )
	perl? ( dev-lang/perl )
	png? ( media-libs/libpng )
	tiff? ( >=media-libs/tiff-3.5.5 )
	xml2? ( >=dev-libs/libxml2-2.4.10 )
	truetype? ( =media-libs/freetype-2* )
	wmf? ( >=media-libs/libwmf-0.2.5 )"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-overflow.patch
}

src_compile() {
	# -mcpu blows up PIC building on x86 + amd64
	case $(tc-arch) in
		x86|amd64) replace-flags "-mcpu" "-mtune" ;;
	esac


	local myconf=""
	myconf="${myconf} $(use_with X x)"
	myconf="${myconf} $(use_with jbig)"
	myconf="${myconf} $(use_with jp2)"
	myconf="${myconf} $(use_with jpeg)"
	myconf="${myconf} $(use_with lcms)"
	myconf="${myconf} $(use_enable lzw)"
	myconf="${myconf} $(use_with png)"
	myconf="${myconf} $(use_with tiff)"
	myconf="${myconf} $(use_with truetype ttf)"
	myconf="${myconf} $(use_with wmf)"
	myconf="${myconf} $(use_with xml2 xml)"

	# Netscape is still used ?  More people should have Mozilla
	sed -i 's:netscape:mozilla:g' configure

	econf \
		--with-gs-font-dir=/usr/share/fonts/default/ghostscript \
		--enable-shared \
		--with-quantum-depth=16 \
		--with-threads \
		--with-bzlib \
		--without-perl \
		${myconf} || die

	# make PerlMagick using portage tools instead of Makefile to avoid sandbox issues
	if use perl ; then
		cd PerlMagick
		perl-app_src_prep
		perl-app_src_compile
		cd ..
	fi

	emake || die "compile problem"
}

src_install() {
	make DESTDIR=${D} install || die

	if use perl ; then
		cd PerlMagick
		perl-module_src_install
		cd ..
	fi

	dosym /usr/lib/${MY_P}/ /usr/lib/GraphicsMagick

	rm -f ${D}/usr/share/GraphicsMagick/*.txt
	rm -rf ${D}/usr/share/${MY_P}/www

	if use doc; then
	    dohtml -r www/*
	fi

	dosed "s:-I/usr/include ::" /usr/bin/GraphicsMagick-config
	dosed "s:-I/usr/include ::" /usr/bin/GraphicsMagick++-config
}
