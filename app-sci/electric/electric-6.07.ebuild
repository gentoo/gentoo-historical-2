# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/electric/electric-6.07.ebuild,v 1.1 2003/03/09 22:12:56 george Exp $

IUSE="motif"

DESCRIPTION="Electric is a sophisticated electrical CAD system that can  handle many forms of circuit design"
HOMEPAGE="http://www.gnu.org/software/electric/electric.html"
SRC_URI="http://ftp.gnu.org/pub/gnu/electric/${P}.tar.gz"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~x86"

DEPEND="virtual/glibc
	motif? ( >=x11-libs/openmotif-2.2.2-r1 )"

RDEPEND=""

src_compile() {
	econf || die "./configure failed"
	emake || die
}

src_install() {
	einstall

	dodoc ChangeLog COPYING README 
}
