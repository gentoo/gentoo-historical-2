# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pygtk/pygtk-0.6.11.ebuild,v 1.5 2003/01/04 11:02:43 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="GTK+ bindings for Python"
SRC_URI="ftp://ftp.gtk.org/pub/gtk/python/v1.2/${P}.tar.gz"
HOMEPAGE="http://www.daa.com.au/~james/pygtk/"

LICENSE="LGPL-2.1"
SLOT="1.2"
KEYWORDS="~x86 ~ppc ~sparc ~alpha"

DEPEND="virtual/python
	>=gnome-base/libglade-0.17-r6
	>=media-libs/imlib-1.8
	>=media-libs/gdk-pixbuf-0.9.0
	=x11-libs/gtk+-1.2*"

src_install() {
	einstall || die
}
