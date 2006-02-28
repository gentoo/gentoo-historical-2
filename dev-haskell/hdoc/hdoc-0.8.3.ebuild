# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/hdoc/hdoc-0.8.3.ebuild,v 1.4 2006/02/28 20:20:24 dcoutts Exp $

DESCRIPTION="A documentation generator for Haskell"
HOMEPAGE="http://www.fmi.uni-passau.de/~groessli/hdoc/"
SRC_URI="http://www.fmi.uni-passau.de/~groessli/hdoc/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64 ~sparc"
IUSE=""

DEPEND="virtual/ghc"
RDEPEND=""

src_compile() {
	econf --with-compiler=ghc || die "econf failed"
	emake || die "emake failed"
}

src_install () {
	# DESTDIR does not work, but only bindir is used ...
	make bindir=${D}/usr/bin install || die "installation failed"
	dodoc docs/hdoc.pdf
}
