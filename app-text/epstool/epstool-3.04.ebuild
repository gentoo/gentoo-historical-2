# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/epstool/epstool-3.04.ebuild,v 1.6 2004/06/24 22:34:59 agriffis Exp $

DESCRIPTION="Creates or extracts preview images in EPS files, fixes bounding boxes,converts to bitmaps."
HOMEPAGE="http://www.cs.wisc.edu/~ghost/gsview/epstool.htm"
SRC_URI="ftp://mirror.cs.wisc.edu/pub/mirrors/ghost/ghostgum/${PN}-${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc amd64"
IUSE=""
DEPEND="virtual/ghostscript"

src_compile() {
	make epstool || die
}

src_install() {
	exeinto /usr/bin
	doexe bin/epstool
	doman doc/epstool.1
	dohtml doc/epstool.htm doc/gsview.css
}
