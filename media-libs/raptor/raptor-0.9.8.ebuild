# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/raptor/raptor-0.9.8.ebuild,v 1.4 2004/03/26 20:56:55 eradicator Exp $

DESCRIPTION="The RDF Parser Toolkit"
HOMEPAGE="http://www.redland.opensource.ac.uk/raptor/"
SRC_URI="http://www.redland.opensource.ac.uk/dist/source/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="curl"
DEPEND="virtual/glibc
	>=dev-libs/libxml2-2.4.24"

DOC="AUTHORS COPYING COPYING.LIB ChangeLog INSTALL LICENSE.txt NEWS README"
HTML="INSTALL.html LICENSE.html MPL.html NEWS.html README.html"

src_compile() {
	econf || die

	# borks with multiple threads
	emake -j1 || die
}

src_install() {
	make DESTDIR=${D} install || die

	dodoc ${DOC}
	dohtml ${HTML}
}
