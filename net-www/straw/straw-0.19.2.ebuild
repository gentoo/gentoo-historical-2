# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/straw/straw-0.19.2.ebuild,v 1.1 2003/10/08 21:24:02 foser Exp $

DESCRIPTION="RSS news aggregator"
HOMEPAGE="http://www.nongnu.org/straw/"
LICENSE="GPL-2"

SRC_URI="http://savannah.nongnu.org/download/${PN}/${PN}.pkg/${PV}/${P}.tar.bz2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""

DEPEND="virtual/python
	>=gnome-base/libglade-2
	>=gnome-base/libgnome-2.0.1
	>=dev-python/gnome-python-1.99.13
	>=dev-python/pygtk-1.99.13-r1
	>=dev-python/bsddb3-3.4.0
	>=dev-python/pyxml-0.8.1
	>=dev-python/egenix-mx-base-2
	=dev-python/adns-python-1.0.0"

src_unpack() {

	unpack ${A}

	cd ${S}
	mv Makefile Makefile.orig
	sed -e "s:-d \$(BINDIR) \$(LIBDIR) \$(DATADIR):-d \$(BINDIR) \$(LIBDIR) \$(DATADIR) \$(APPLICATIONSDIR) \$(ICONDIR):" Makefile.orig > Makefile || die

}

src_compile() {

	emake || die

}

src_install() {

	emake PREFIX=${D}/usr install || die

	dodoc NEWS README TODO

}
