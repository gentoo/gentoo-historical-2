# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/cabextract/cabextract-0.6.ebuild,v 1.1 2002/10/17 19:57:45 azarah Exp $

S="${WORKDIR}/${P}"
DESCRIPTION="Extracts files from Microsoft .cab files"
SRC_URI="http://www.kyz.uklinux.net/downloads/${P}.tar.gz"
HOMEPAGE="http://www.kyz.uklinux.net/cabextract.php3"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc sparc64 alpha"

DEPEND="virtual/glibc"

src_compile() {
	econf || die
	emake || die
}

src_install() {
	dobin cabextract
	doman cabextract.1
	dodoc COPYING NEWS README TODO AUTHORS
}
