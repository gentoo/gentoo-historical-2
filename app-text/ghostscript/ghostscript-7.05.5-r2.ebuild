# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/ghostscript/ghostscript-7.05.5-r2.ebuild,v 1.2 2003/02/13 09:37:11 vapier Exp $

DESCRIPTION="ESP Ghostscript -- an enhanced version of GNU Ghostscript with better printer support"
SRC_URI="ftp://ftp.easysw.com/pub/ghostscript/espgs-${PV}-source.tar.bz2
	ftp://ftp.easysw.com/pub/ghostscript/gnu-gs-fonts-std-6.0.tar.gz
	ftp://ftp.easysw.com/pub/ghostscript/gnu-gs-fonts-other-6.0.tar.gz
	cjk? ( ftp://ftp.gyve.org/pub/gs-cjk/adobe-cmaps-200204.tar.gz
		ftp://ftp.gyve.org/pub/gs-cjk/acro5-cmaps-2001.tar.gz)"
HOMEPAGE="http://www.easysw.com/"

SLOT="0"
LICENSE="GPL-2 LGPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~alpha"
IUSE="X cups gnome cjk"

DEPEND="virtual/glibc
	>=media-libs/jpeg-6b 
	>=media-libs/libpng-1.2.1
	>=sys-libs/zlib-1.1.4
	X? ( virtual/x11 ) 
	gnome? ( >=media-gfx/gimp-print-4.2.1 )
	cjk? ( x11-misc/arphicfonts
		x11-misc/kochi-fonts
		x11-misc/baekmuk-fonts )"

S=${WORKDIR}/espgs-${PV}

src_unpack() {
	unpack espgs-${PV}-source.tar.bz2
	unpack gnu-gs-fonts-std-6.0.tar.gz
	unpack gnu-gs-fonts-other-6.0.tar.gz

	# Brother HL-12XX support
	cp ${FILESDIR}/gs7.05-gdevhl12.c ${S}/src/gdevhl12.c || die
	mv ${S}/src/Makefile.in ${S}/src/Makefile.in.orig
	sed 's#^\(DEVICE_DEVS6=.*\)$#\1 $(DD)hl1240.dev $(DD)hl1250.dev#' \
		${S}/src/Makefile.in.orig > ${S}/src/Makefile.in || die

	patch -p0 < ${FILESDIR}/png.diff || die "patch failed"

	if [ -n `use cjk` ] ; then
		patch -p0 < ${FILESDIR}/gs7.05-cjk.diff || die "patch failed"
	fi
	# man page patch from absinthe@pobox.com (Dylan Carlson) bug #14150
	patch -p0 ${S}/man/gs.1 < ${FILESDIR}/${P}.man.patch
}

src_compile() {
	local myconf
	myconf="--with-ijs --with-omni"

	use X && myconf="${myconf} --with-x --with-gimp-print" \
		|| myconf="${myconf} --without-x --without-gimp-print" 

	use cups && myconf="${myconf} --enable-cups" \
		|| myconf="${myconf} --disable-cups"

	use gnome && myconf="${myconf} --with-gimp-print" \
		|| myconf="${myconf} --without-gimp-print"

	econf ${myconf}
	make || die "make failed"
}

src_install() {
	einstall install_prefix=${D}

	cd ${WORKDIR}
	cp -a fonts ${D}/usr/share/ghostscript || die
	cd ${S}

	rm -fr ${D}/usr/share/ghostscript/7.05/doc || die
	dodoc doc/README doc/COPYING doc/COPYING.LGPL
	dohtml doc/*.html doc/*.htm
	insinto /usr/share/emacs/site-lisp
	doins doc/gsdoc.el || die

	if [ `use cjk` ] ; then
		dodir /usr/share/ghostscript/Resource
		dodir /usr/share/ghostscript/Resource/Font
		dodir /usr/share/ghostscript/Resource/CIDFont
		cd ${D}/usr/share/ghostscript/Resource
		unpack adobe-cmaps-200204.tar.gz
		unpack acro5-cmaps-2001.tar.gz
	fi
}
