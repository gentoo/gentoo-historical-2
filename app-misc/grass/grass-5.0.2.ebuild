# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/grass/grass-5.0.2.ebuild,v 1.9 2004/03/30 06:51:50 spyderous Exp $

DESCRIPTION="An open-source GIS with raster and vector functionality."
HOMEPAGE="http://grass.itc.it/"
SRC_URI="http://grass.ibiblio.org/${PN}5/source/${P}_src.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

IUSE="tcltk png jpeg tiff postgres odbc gd motif truetype"
# Removed cause mesa never goes stable.
# IUSE="${IUSE} nviz"

DEPEND=">=sys-devel/make-3.80
	>=sys-libs/zlib-1.1.4
	>=sys-devel/flex-2.5.4a
	>=sys-devel/bison-1.35
	>=sys-libs/ncurses-5.3
	virtual/x11
	>=sys-libs/gdbm-1.8.0
	>=sys-devel/gcc-3.2.2
	=dev-libs/fftw-2*
	>=app-sci/lapack-3.0
	>=app-sci/blas-19980702
	>=media-libs/netpbm-9.12
	>=dev-lang/R-1.6.1
	tcltk? ( >=dev-lang/tcl-8.3.4
		>=dev-lang/tk-8.3.4 )
	png? ( >=media-libs/libpng-1.2.5 )
	jpeg? ( >=media-libs/jpeg-6b )
	tiff? ( >=media-libs/tiff-3.5.7 )
	postgres? ( >=dev-db/postgresql-7.3.2 )
	odbc? ( >=dev-db/unixODBC-2.0.6 )
	gd? ( >=media-libs/libgd-1.8.3 )
	motif? ( x11-libs/openmotif )
	truetype? ( >=media-libs/freetype-2.1.3 )"
	#nviz? ( >=media-libs/mesa-3.5 )"

S=${WORKDIR}/${P/-/}

src_compile() {

	local myconf="--with-blas --with-lapack"

	use tcltk \
	&& myconf="${myconf} --with-tcltk" \
	|| myconf="${myconf} --without-tcltk"

	use png \
	&& myconf="${myconf} --with-png" \
	|| myconf="${myconf} --without-png"

	use jpeg \
	&& myconf="${myconf} --with-jpeg" \
	|| myconf="${myconf} --without-jpeg"

	use tiff \
	&& myconf="${myconf} --with-tiff" \
	|| myconf="${myconf} --without-tiff"

	use odbc \
	&& myconf="${myconf} --with-odbc" \
	|| myconf="${myconf} --without-odbc"

	use gd \
	&& myconf="${myconf} --with-gd" \
	|| myconf="${myconf} --without-gd"

	use postgres \
	&& myconf="${myconf} --with-postgres --with-postgres-includes=/usr/include/postgresql/server" \
	|| myconf="${myconf} --without-postgres"

	use motif \
	&& myconf="${myconf} --with-motif --with-motif-includes=/usr/X11R6/include" \
	|| myconf="${myconf} --without-motif"

	use truetype \
	&& myconf="${myconf} --with-freetype --with-freetype-includes=/usr/include/freetype2" \
	|| myconf="${myconf} --without-freetype"

	#use nviz \
	#&& myconf="${myconf} --with-glw" \
	#|| myconf="${myconf} --without-glw"

	./configure \
		--host=${CHOST} \
		--prefix=${D}/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		${myconf} || die "./configure failed"
	make || die "make failed"
}

src_install() {
	make install || die
	dosed "s:^GISBASE=.*$:GISBASE=/usr/grass5:" \
	  /usr/bin/grass5
}
