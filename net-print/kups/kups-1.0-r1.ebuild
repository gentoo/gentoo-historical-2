# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Your Name <your email>
# $Header: /var/cvsroot/gentoo-x86/net-print/kups/kups-1.0-r1.ebuild,v 1.2 2001/11/16 12:50:42 danarmak Exp $
. /usr/portage/eclass/inherit.eclass || die
inherit kde-base || die

need-kdelibs 2.1.1

DESCRIPTION="A CUPS front-end for KDE"
SRC_URI="ftp://cups.sourceforge.net/pub/cups/kups/${P}.tar.gz"
HOMEPAGE="http://cups.sourceforge.net/kups/"

DEPEND="$DEPEND
		>=net-print/qtcups-2.0"
RDEPEND="$RDEPEND
		>=net-print/qtcups-2.0"

src_compile() {

	rm configure
	autoconf || die

	CFLAGS="${CFLAGS} -L/usr/X11R6/lib"
	kde_src_compile

}

src_install () {
	make DESTDIR=${D} CUPS_MODEL_DIR=/usr/share/cups/model install
    kde_src_install dodoc
}

