# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/pstotext/pstotext-1.8g.ebuild,v 1.14 2005/07/16 16:13:38 josejx Exp $

DESCRIPTION="extract ASCII text from a PostScript or PDF file"
HOMEPAGE="http://research.compaq.com/SRC/virtualpaper/pstotext.html"
SRC_URI="http://research.compaq.com/SRC/virtualpaper/binaries/pstotext.tar.Z"

LICENSE="PSTT"
SLOT="0"
KEYWORDS="~amd64 ppc ppc64 sparc x86"
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
