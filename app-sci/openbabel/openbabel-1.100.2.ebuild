# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/openbabel/openbabel-1.100.2.ebuild,v 1.5 2004/05/15 09:45:07 kugelfang Exp $

DESCRIPTION="Open Babel interconverts file formats used in molecular modeling."

SRC_URI="mirror://sourceforge/openbabel/${P}.tar.gz"
HOMEPAGE="http://openbabel.sourceforge.net/"
KEYWORDS="x86 sparc ppc ~amd64"

SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND="!app-sci/babel"

src_compile() {
	econf || die "configure failed"
	emake || die "make failed"
}

src_install () {

	make DESTDIR=${D} install || die
	dohtml doc/FAQ.html doc/Migration.html doc/dioxin.png
	dodoc 	README \
		doc/README.dioxin.pov \
		doc/README.povray \
		doc/babel31.inc \
		doc/dioxin.inc \
		doc/dioxin.mol2 \
		doc/dioxin.pov
	doman doc/babel.1

}

