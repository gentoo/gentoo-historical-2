# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/sim4/sim4-20030921.ebuild,v 1.1 2004/06/22 16:36:47 ribosome Exp $

DESCRIPTION="A program to align cDNA and genomic DNA"
HOMEPAGE="http://globin.cse.psu.edu/html/docs/sim4.html"
SRC_URI="http://globin.cse.psu.edu/ftp/dist/sim4/sim4.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86"
IUSE=""

S=${WORKDIR}/${PN}.2003-09-21

src_compile() {
	emake || die
}

src_install() {
	dobin sim4
	dodoc README.psublast README.sim4 VERSION
}
