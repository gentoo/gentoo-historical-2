# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gtkam/gtkam-0.1.9.ebuild,v 1.1 2002/10/23 18:59:26 spider Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A frontend for gPhoto 2"
HOMEPAGE="http://gphoto.org/gphoto2/gtk.html"
SRC_URI="mirror://sourceforge/gphoto/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

DEPEND="=x11-libs/gtk+-1.2*
	>=media-libs/gdk-pixbuf-0.17.0
	>=media-gfx/gphoto2-2.1.0"

RDEPEND="${DEPEND}"


src_compile() {
	econf --without-gimp || die
	emake || die
}

src_install () {

	einstall || die

	dodoc ABOUT-NLS AUTHORS COPYING INSTALL MANUAL NEWS README
}
