# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gimp-print/gimp-print-4.2.2.ebuild,v 1.10 2003/03/07 22:48:58 vapier Exp $

inherit libtool

DESCRIPTION="Gimp Plugin and Ghostscript driver for Gimp"
SRC_URI="mirror://sourceforge/gimp-print/${P}.tar.gz"
HOMEPAGE="http://gimp-print.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc alpha sparc"
IUSE="cups doc nls"

DEPEND="=x11-libs/gtk+-1.2*
	=media-gfx/gimp-1.2*
	app-text/ghostscript
	net-print/foomatic
	doc? ( app-text/texi2html )
	cups? ( >=net-print/cups-1.1.16 )"
RDEPEND="virtual/glibc"

src_compile() {
	elibtoolize
	aclocal

	econf \
		--with-ghost \
		--sysconfdir=/etc/gimp/1.2/ \
		--with-gimp-exec-prefix=/usr \
		--with-testpattern \
		`use_with cups` \
		`use_enable nls` \
		${myconf} || die

	cp src/gimp/Makefile src/gimp/Makefile.orig
	sed -e 's:--install-admin-bin:--install-bin:g' \
		src/gimp/Makefile.orig >src/gimp/Makefile
	
	emake || die
}

src_install() {
	dodir /usr/lib/gimp/1.2/.gimp-1.2/plug-ins/print

	make \
		DESTDIR=${D} \
		HOME=/usr/lib/gimp/1.2 \
		install || die "make install failed"

	# NOTE: this build uses gimptool to install the plugin, so
	# if we dont do it this way, it will install to / no
	# matter what.
	#
	# NOTE to whoever commented this: Please DO NOT!
	mv ${D}/usr/lib/gimp/1.2/.gimp-1.2/plug-ins/ \
		${D}/usr/lib/gimp/1.2/
	rm -rf ${D}/usr/lib/gimp/1.2/.gimp-1.2/
	     
	dodoc AUTHORS ChangeLog COPYING NEWS README*
	dohtml -r doc
}
