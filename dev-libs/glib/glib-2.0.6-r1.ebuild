# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-libs/glib/glib-2.0.6-r1.ebuild,v 1.1 2002/08/04 07:42:40 spider Exp $

inherit libtool

S=${WORKDIR}/${P}
DESCRIPTION="The GLib library of C routines"
SRC_URI="ftp://ftp.gtk.org/pub/gtk/v2.0/${P}.tar.bz2"
HOMEPAGE="http://www.gtk.org/"

SLOT="2"
LICENSE="LGPL-2.1"
KEYWORDS="x86 ppc"

DEPEND=">=dev-util/pkgconfig-0.12.0
	doc? ( >=dev-util/gtk-doc-0.9-r2 )"


# libiconv breaks other stuff

RDEPEND="virtual/glibc"

src_compile() {
	# Seems libtool have another wierd bug, try to fix it
	# with a fix for nautilus, bug #4190
	elibtoolize --reverse-deps
	
	local myconf=""
	use doc && myconf="${myconf} --enable-gtk-doc"
	use doc || myconf="${myconf} --disable-gtk-doc"

	econf \
		--with-threads=posix \
		${myconf} || die

	emake || die
}

src_install() {
	einstall || die
    
	dodoc AUTHORS ChangeLog COPYING README* INSTALL NEWS NEWS.pre-1-3 TODO.xml
}
