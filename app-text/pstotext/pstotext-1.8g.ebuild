# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/pstotext/pstotext-1.8g.ebuild,v 1.13 2005/06/02 06:00:57 wormo Exp $

DESCRIPTION="extract ASCII text from a PostScript or PDF file"
HOMEPAGE="http://research.compaq.com/SRC/virtualpaper/pstotext.html"
SRC_URI="http://research.compaq.com/SRC/virtualpaper/binaries/pstotext.tar.Z"

LICENSE="PSTT"
SLOT="0"
KEYWORDS="x86 sparc ~ppc ppc64 ~amd64"
IUSE=""

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
