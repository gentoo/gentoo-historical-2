# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/root-tail/root-tail-0.9.ebuild,v 1.7 2004/09/02 16:56:11 pvdabeel Exp $

DESCRIPTION="Terminal to display (multiple) log files on the root window"
HOMEPAGE="http://www.goof.com/pcg/marc/root-tail.html"
SRC_URI="http://www.goof.com/pcg/marc/data/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~sparc ~amd64 ppc"
IUSE=""

DEPEND="virtual/x11"

src_compile() {
	make -f Makefile.simple || die
}

src_install() {
	dobin root-tail
	newman root-tail.man root-tail.1
}
