# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/gtkwave/gtkwave-2.0.0_pre20030319.ebuild,v 1.2 2005/01/10 00:09:22 weeve Exp $

MY_P=${P/_pre/pre3-}
DESCRIPTION="A wave viewer for LXT and Verilog VCD/EVCD files"
HOMEPAGE="http://www.cs.man.ac.uk/apt/tools/gtkwave/index.html"
SRC_URI="ftp://ftp.cs.man.ac.uk/pub/amulet/gtkwave/snapshots/${MY_P}.tar.gz"

IUSE=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~sparc ~ppc"

DEPEND="virtual/x11
	=x11-libs/gtk+-1.2*
	=dev-libs/glib-1.2*
	app-arch/bzip2"

S=${WORKDIR}/${MY_P}

src_compile() {
	econf || die
	emake || die
}

src_install() {
	emake DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog README
	dohtml -r doc/*
}
