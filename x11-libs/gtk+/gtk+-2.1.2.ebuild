# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/gtk+/gtk+-2.1.2.ebuild,v 1.3 2002/11/21 19:51:00 azarah Exp $

IUSE="tiff doc jpeg directfb"

inherit eutils libtool flag-o-matic debug

SLOT="2"
KEYWORDS="x86"

S="${WORKDIR}/${P}"
DESCRIPTION="Gimp ToolKit + "
SRC_URI="ftp://ftp.gtk.org/pub/gtk/v2.1/${P}.tar.bz2"
HOMEPAGE="http://www.gtk.org/"
LICENSE="LGPL-2.1"

RDEPEND="virtual/x11
	>=dev-libs/glib-2.0.6-r1
	=dev-libs/atk-1.1*
	=x11-libs/pango-1.1*
	>=media-libs/libpng-1.2.1
	jpeg? ( >=media-libs/jpeg-6b-r2 )
	tiff? ( >=media-libs/tiff-3.5.7 )
	directfb? ( dev-libs/DirectFB )"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0
	 doc? ( >=dev-util/gtk-doc-0.9 
		app-text/sgmltools-lite )"

src_unpack() {
	unpack ${A}

	# Turn of --export-symbols-regex for now, since it removes
	# the wrong symbols
	cd ${S}; epatch ${FILESDIR}/gtk+-2.0.6-exportsymbols.patch
}

src_compile() {
	# see bug 8762
	replace-flags "-O3" "-O2"

	elibtoolize
	
	local myconf=""
	use doc && myconf="${myconf} --enable-gtk-doc" || myconf="${myconf} --disable-gtk-doc"
	use jpeg ||  myconf="${myconf} --without-libjpeg"
	use tiff ||  myconf="${myconf} --without-libtiff"
	if [ -n "$DEBUG" ]; then
		myconf="${myconf}  --enable-debug"
	fi
		
	econf --with-gdktarget=x11 ${myconf} || die

	# gtk+ isn't multithread friendly due to some obscure code generation bug
	make || die
}

src_install() {
	dodir /etc/gtk-2.0
	make DESTDIR=${D} \
		prefix=/usr \
		sysconfdir=/etc \
		infodir=/usr/share/info \
		mandir=/usr/share/man \
		install || die
	dodoc AUTHORS COPYING ChangeLog* HACKING* INSTALL NEWS* README* TODO
}


pkg_postinst() {
	gtk-query-immodules-2.0 >	/etc/gtk-2.0/gtk.immodules
	gdk-pixbuf-query-loaders >	/etc/gtk-2.0/gdk-pixbuf.loaders
}

