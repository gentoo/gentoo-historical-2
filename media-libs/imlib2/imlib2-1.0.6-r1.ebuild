# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/imlib2/imlib2-1.0.6-r1.ebuild,v 1.19 2003/11/03 21:54:58 vapier Exp $

inherit libtool flag-o-matic

DESCRIPTION="Version 2 of an advanced replacement library for libraries like libXpm"
HOMEPAGE="http://enlightenment.org/"
SRC_URI="mirror://sourceforge/enlightenment/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 ppc sparc ~alpha ~mips ~hppa amd64"

DEPEND="=x11-libs/gtk+-1.2*
	>=media-libs/giflib-4.1.0
	>=media-libs/libpng-1.2.1
	>=media-libs/tiff-3.5.5
	=media-libs/freetype-1*
	virtual/x11"

src_compile() {
	replace-flags k6-3 i586
	replace-flags k6-2 i586
	replace-flags k6 i586

	# always turn off mmx because binutils 2.11.92+
	# seems to be broken for this package
	elibtoolize

	local myconf

	myconf="--disable-mmx"

	econf \
		--sysconfdir=/etc/X11/imlib \
		${myconf} || die

	emake || die
}

src_install() {
	make prefix=${D}/usr sysconfdir=${D}/etc/X11/imlib install || die
	preplib /usr
	dodoc AUTHORS COPYING* ChangeLog README
	dohtml -r doc
}
