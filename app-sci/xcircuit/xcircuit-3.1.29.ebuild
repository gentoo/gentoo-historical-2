# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/xcircuit/xcircuit-3.1.29.ebuild,v 1.2 2003/12/09 18:11:38 lanius Exp $

S=${WORKDIR}/${P}

DESCRIPTION="Circuit drawing and schematic capture program."
SRC_URI="http://xcircuit.ece.jhu.edu/archive/${P}.tar.bz2"
HOMEPAGE="http://xcircuit.ece.jhu.edu"

KEYWORDS="x86 ~ppc"
SLOT="0"
LICENSE="GPL-2"

DEPEND="virtual/x11
	virtual/ghostscript"


src_compile() {

	aclocal && autoconf || die "Could not recreate configuration files!"
	econf || die "Configuration failed"
	make || die

}

src_install () {

	make DESTDIR=${D} install || die "Installation failed"
	dodoc COPYRIGHT README*

}
