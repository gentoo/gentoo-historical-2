# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/bow/bow-20020213.ebuild,v 1.4 2004/06/24 22:28:34 agriffis Exp $

DESCRIPTION="Bag of words library - Statistical language modeling, text retrieval, Classification and clustering"
HOMEPAGE="http://www-2.cs.cmu.edu/~mccallum/bow/"
SRC_URI="http://www-2.cs.cmu.edu/~mccallum/bow/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc"
IUSE=""

DEPEND="virtual/glibc"

src_compile() {
	econf --prefix=${D}/usr --datadir=${D}/usr/share || die
}

src_install() {
	make prefix=${D}/usr install
}
