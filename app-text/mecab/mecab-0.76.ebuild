# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/mecab/mecab-0.76.ebuild,v 1.5 2004/07/01 11:59:39 eradicator Exp $

MY_IPADIC="ipadic-2.5.1"
DESCRIPTION="Yet Another Part-of-Speech and Morphological Analyzer"
HOMEPAGE="http://cl.aist-nara.ac.jp/~taku-ku/software/mecab/"
SRC_URI="http://cl.aist-nara.ac.jp/~taku-ku/software/mecab/src/${P}.tar.gz
	http://chasen.aist-nara.ac.jp/stable/ipadic/${MY_IPADIC}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86 ~sparc ~ppc"
IUSE=""

DEPEND="virtual/libc
	dev-lang/perl"

src_compile() {
	ln -s ${WORKDIR}/${MY_IPADIC} dic/${MY_IPADIC}
	econf || die
	make || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog INSTALL NEWS README
}
