# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/pstotext/pstotext-1.8g.ebuild,v 1.6 2004/02/22 20:05:25 agriffis Exp $

DESCRIPTION="extract ASCII text from a PostScript or PDF file"
HOMEPAGE="http://research.compaq.com/SRC/virtualpaper/pstotext.html"
SRC_URI="http://research.compaq.com/SRC/virtualpaper/binaries/pstotext.tar.Z"

LICENSE="PSTT"
SLOT="0"
KEYWORDS="x86 sparc"

DEPEND="app-arch/ncompress"

RDEPEND="virtual/ghostscript"

S=${WORKDIR}/${PN}

src_compile() {
	emake || die
}

src_install () {
	into /usr
	dobin pstotext
	doman pstotext.1
}
