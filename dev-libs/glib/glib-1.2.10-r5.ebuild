# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/glib/glib-1.2.10-r5.ebuild,v 1.4 2003/01/18 13:38:30 tuxus Exp $

inherit libtool

S="${WORKDIR}/${P}"
DESCRIPTION="The GLib library of C routines"
SRC_URI="ftp://ftp.gtk.org/pub/gtk/v1.2/${P}.tar.gz
	 ftp://ftp.gnome.org/pub/GNOME/stable/sources/glib/${P}.tar.gz"
HOMEPAGE="http://www.gtk.org/"

SLOT="1"
LICENSE="LGPL-2.1"
KEYWORDS="x86 ppc sparc alpha mips"

DEPEND="virtual/glibc"

src_compile() {

	elibtoolize

	econf \
		--with-threads=posix \
		--enable-debug=yes || die

	if [ "${ARCH}" = "alpha" ] ; then
		emake CFLAGS="${CFLAGS} -fPIC" || die
	else
		emake || die
	fi
}

src_install() {
	einstall || die
    
	( cd ${D}/usr/lib ; chmod 755 libgmodule-1.2.so.* )

	dodoc AUTHORS ChangeLog COPYING README* INSTALL NEWS

	dohtml -r docs
}

