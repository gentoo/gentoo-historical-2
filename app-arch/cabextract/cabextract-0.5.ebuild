# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/app-arch/cabextract/cabextract-0.5.ebuild,v 1.6 2002/07/25 14:16:07 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Extracts files from Microsoft .cab files"
SRC_URI="http://www.kyz.uklinux.net/downloads/${P}.tar.gz"
HOMEPAGE="http://www.kyz.uklinux.net/cabextract.php3"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

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
