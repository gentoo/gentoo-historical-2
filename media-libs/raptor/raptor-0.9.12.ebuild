# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/raptor/raptor-0.9.12.ebuild,v 1.1 2003/10/16 19:43:04 mholzer Exp $

DESCRIPTION="The RDF Parser Toolkit"
HOMEPAGE="http://www.redland.opensource.ac.uk/raptor/"
SRC_URI="http://www.redland.opensource.ac.uk/dist/source/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND="virtual/glibc
	>=dev-libs/libxml2-2.4.24"
S=${WORKDIR}/${P}

src_compile() {
	econf || die
	emake || die
}

src_install() {
	einstall || die
}
