# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/ghostscript/ghostscript-7.05.3-r1.ebuild,v 1.10 2003/02/13 09:37:02 vapier Exp $

S=${WORKDIR}/espgs-${PV}
DESCRIPTION="ESP Ghostscript -- an enhanced version of GNU Ghostscript with better printer support"
SRC_URI="ftp://ftp.easysw.com/pub/ghostscript/espgs-${PV}-source.tar.bz2
	ftp://ftp.easysw.com/pub/ghostscript/gnu-gs-fonts-std-6.0.tar.gz
	ftp://ftp.easysw.com/pub/ghostscript/gnu-gs-fonts-other-6.0.tar.gz
	http://lxm3200.sourceforge.net/lxm3200-0.4.1-gs5.50-src.tar.gz"
HOMEPAGE="http://www.easysw.com/"

SLOT="0"
LICENSE="GPL-2 LGPL-2"
KEYWORDS="x86 ppc sparc "
IUSE="X cups"

DEPEND=">=media-libs/jpeg-6b 
	>=media-libs/libpng-1.2.1
	>=sys-libs/zlib-1.1.4
	X? ( virtual/x11 )"

src_unpack() {
	unpack espgs-${PV}-source.tar.bz2
	unpack gnu-gs-fonts-std-6.0.tar.gz
	unpack gnu-gs-fonts-other-6.0.tar.gz
	unpack lxm3200-0.4.1-gs5.50-src.tar.gz
	cat ${FILESDIR}/lxm3200-cups.diff | patch -p1 -d ${S} || die "lxm3200 patch failed"
	cp ${WORKDIR}/lxm3200-0.4.1-gs5.50-src/gdevlx32.c ${S}/src/ || die
	# Brother HL-12XX support
	cp ${FILESDIR}/gs7.05-gdevhl12.c ${S}/src/gdevhl12.c || die
	mv ${S}/src/Makefile.in ${S}/src/Makefile.in.orig
	sed 's#^\(DEVICE_DEVS6=.*\)$#\1 $(DD)hl1240.dev $(DD)hl1250.dev#' \
		${S}/src/Makefile.in.orig > ${S}/src/Makefile.in || die
}

src_compile() {
	use X && myconf="--with-x" || myconf="--without-x" 
	use cups && myconf="${myconf} --enable-cups" || myconf="${myconf} --disable-cups"

	econf --with-gimp-print ${myconf}
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
}
