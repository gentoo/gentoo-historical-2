# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/freehdl/freehdl-20040113.ebuild,v 1.3 2004/07/01 11:51:39 eradicator Exp $

DESCRIPTION="A free VHDL simulator."
SRC_URI="http://cran.mit.edu/~enaroska/${P}.tar.gz"
HOMEPAGE="http://freehdl.seul.org/"
LICENSE="GPL-2"
DEPEND="virtual/libc"
SLOT="0"
IUSE=""
KEYWORDS="~ppc"

src_install () {
	emake DESTDIR=${D} install || die "installation failed"
	dodoc AUTHORS ChangeLog COPYING INSTALL NEWS README
}
