# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/wxGTK/wxGTK-2.3.2-r2.ebuild,v 1.15 2002/12/09 04:41:49 manson Exp $

IUSE="nls odbc jpeg png opengl"

S=${WORKDIR}/${P}

DESCRIPTION="GTK+ version of wxWindows, a cross-platform C++ GUI toolkit."
SRC_URI="mirror://sourceforge/wxwindows/${P}.tar.bz2"
HOMEPAGE="http://www.wxwindows.org/"

LICENSE="LGPL-2"
SLOT="2.3"
KEYWORDS="x86 ppc sparc "

DEPEND="dev-libs/libunicode
	media-libs/netpbm
	media-libs/giflib
	png? ( media-libs/libpng )
	jpeg? ( media-libs/jpeg )
	media-libs/tiff
	odbc? ( dev-db/unixODBC  )
	opengl? ( virtual/opengl )
	=x11-libs/gtk+-1.2*"
RDEPEND="nls? ( sys-devel/gettext )"

pkg_setup() {
	# xfree should not install these, remove until the fixed
	# xfree is in main use.
	rm -f /usr/X11R6/include/{zconf.h,zlib.h}
}

src_compile() {
	local myconf

	# Build static library too, shared library is enabled by default.
	# Enable useful config options that don't have USE flags
	# motif is not a supported build environment.  forcing gtk
	myconf="${myconf} --enable-static --with-zlib --with-unicode \
		--with-libtiff --with-gtk --enable-gif"
	
	#Note: pcx image support enabled by default if found.
	#Also, all wxWindows gui features are enabled by default. If you
	#want to build a smaller library you can disable features by adding
	#the appropriate flags to myconf (see INSTALL.txt).

	#The build tools include a --with-freetype option, however it doesn't
	#seem to be implemented in the source yet.
	
	#confiure options that have corresponding USE variable.
	
	use odbc \
		&& myconf="${myconf} --with-odbc" \
		|| myconf="${myconf} --without-odbc"

	use opengl \
		&& myconf="${myconf} --with-opengl" \
		|| myconf="${myconf} --without-opengl"

	use png \
		&& myconf="${myconf} --with-libpng --enable-pnm" \
		|| myconf="${myconf} --without-libpng --disable-pnm"
	
	use jpeg \
		&& myconf="${myconf} --with-libjpeg" \
		|| myconf="${myconf} --without-libjpeg"

	gunzip < ${FILESDIR}/${P}.diff.gz | patch -p1
	
	econf ${myconf} || die "configuration failed"
	
	make || die "make failed"
}

src_install() {
	einstall || die
	dodoc *.txt
}
