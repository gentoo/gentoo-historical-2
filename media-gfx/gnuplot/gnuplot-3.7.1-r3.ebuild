# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gnuplot/gnuplot-3.7.1-r3.ebuild,v 1.12 2003/02/13 12:33:41 vapier Exp $

IUSE="X readline svga plotutils"

S=${WORKDIR}/${P}
DESCRIPTION="Quick and useful plotting program"
SRC_URI="ftp://ftp.gnuplot.org/pub/gnuplot/${P}.tar.gz"
HOMEPAGE="http://www.gnuplot.info"

SLOT="0"
LICENSE="gnuplot"
KEYWORDS="x86 ppc ~alpha"

DEPEND="media-libs/libpng
	X? ( virtual/x11 )
	svga? ( media-libs/svgalib )
	readline? ( sys-libs/readline )
	plotutils? ( media-libs/plotutils )"

src_compile() {
	local myconf
	#--with-lasergnu flag seems to be broken and I'm too lazy to fix now
	#myconf=" --with-png --without-gd --with-lasergnu"
	myconf=" --with-png --without-gd --with-plot=/usr/lib"
	#--with-plot enables the Gnu plotutils library
	#need to specify path to differentiate from Unix plot

	use plotutils \
		&& myconf="${myconf} --with-plot=/usr/lib" \
		|| myconf="${myconf} --without-plot"

	use X \
		&& myconf="${myconf} --with-x" \
		|| myconf="${myconf} --without-x"

	use readline \
		&& myconf="${myconf} --with-readline=gnu" \
		|| myconf="${myconf} --with-readline"

	use svga \
		&& myconf="${myconf} --with-linux-vga" \
		|| myconf="${myconf} --without-linux-vga"

	econf \
		--datadir=/usr/share/gnuplot \
		${myconf} || die

	mv Makefile Makefile.orig
	sed -e 's/datadir = \/usr/datadir = ${prefix}/' \
	    -e 's/mandir = \/usr/mandir = ${prefix}/' \
	    Makefile.orig > Makefile

	cd docs
	mv Makefile Makefile.orig
	sed -e 's/datadir = \/usr/datadir = ${prefix}/' \
		Makefile.orig > Makefile

	cd ${S}
	emake || die
}

src_install () {
	make prefix=${D}/usr install || die

	dodoc 0* ChangeLog CodeStyle Copyright NEWS PGPKEYS TODO
}

pkg_postinst() {
	if [ "`use svga`" ] ; then
		einfo "In order to enable ordinary users to use SVGA console graphics"
		einfo "gnuplot needs to be set up as setuid root.  Please note that"
		einfo "this is usually considered to be a security hazard."
		einfo "As root, manually chmod u+s /usr/bin/gnuplot"
	fi
}
