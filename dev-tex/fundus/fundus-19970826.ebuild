# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/fundus/fundus-19970826.ebuild,v 1.5 2004/05/06 16:03:47 ciaranm Exp $

inherit latex-package

S=${WORKDIR}/${PN}
DESCRIPTION="Providing LaTeX access to various font families"
HOMEPAGE="http://www.ctan.org/tex-archive/help/Catalogue/entries/fundus.html"
# Taken from: ftp://ftp.dante.de/tex-archive/macros/latex/contrib/gene/fundus.tar.gz
#	ftp://ftp.dante.de/tex-archive/fonts/twcal.tar.gz
#	ftp://ftp.dante.de/tex-archive/fonts/va.tar.gz
#	ftp://ftp.dante.de/tex-archive/fonts/la.tar.gz
#	ftp://ftp.dante.de/tex-archive/fonts/calligra.tar.gz
SRC_URI="mirror://gentoo/${P}.tar.gz
	mirror://gentoo/${PN}-fonts.tar.gz"
IUSE=""
SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ~amd64 ~sparc"

src_unpack() {
	unpack ${A}
	cd ${S}
	for i in *.tar.gz ; do
		tar xzf $i
	done
}

src_install() {
	latex-package_src_install

	for f in va la twcal calligra ; do
		pushd $f
		insinto /usr/share/texmf/fonts/source/public/$f
		doins *.mf
		popd
	done
}
