# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Martin Schlemmer <azarah@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-news/pan/pan-0.11.1.93.ebuild,v 1.1 2002/01/29 21:56:59 azarah Exp $


S=${WORKDIR}/${P}
DESCRIPTION="A newsreader for GNOME."
SRC_URI="http://pan.rebelbase.com/download/${PV}/SOURCE/${P}.tar.bz2"
HOMEPAGE="http://pan.rebelbase.com/"

DEPEND="virtual/x11 
        nls? ( sys-devel/gettext )
	>=gnome-base/gnome-libs-1.4.1.2-r1
	>=media-libs/gdk-pixbuf-0.11.0-r1
	>=dev-libs/libxml-1.8.11
        gtkhtml? ( >=gnome-extra/gtkhtml-0.14.0-r1 )"

src_compile() {
        local myconf

	use nls     || myconf=--disable-nls
	use gtkhtml && myconf="$myconf --enable-html"

	./configure --host=${CHOST} 					\
		    --prefix=/usr					\
		    --sysconfdir=/etc 					\
		    $myconf || die

	# Doesn't work with -j 4 (hallski)
	make || die
}

src_install () {
	make prefix=${D}/usr sysconfdir=${D}/etc install

	dodoc AUTHORS COPYING ChangeLog NEWS README TODO
}
