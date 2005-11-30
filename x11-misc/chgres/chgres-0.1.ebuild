# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/chgres/chgres-0.1.ebuild,v 1.1.1.1 2005/11/30 09:40:38 chriswhite Exp $

IUSE=""
DESCRIPTION="A very simple command line utility for changing X resolutions"
HOMEPAGE="http://hpwww.ec-lyon.fr/~vincent/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc x86"

SRC_URI="http://hpwww.ec-lyon.fr/~vincent/${P}.tar.gz"

DEPEND="virtual/x11"

src_compile() {
	emake || die
}

src_install() {
	exeinto /usr/bin
	doexe chgres
	dodoc README
}
