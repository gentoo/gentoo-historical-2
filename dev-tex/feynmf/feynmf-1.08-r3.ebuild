# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/feynmf/feynmf-1.08-r3.ebuild,v 1.6 2008/10/30 10:18:21 armin76 Exp $

inherit eutils latex-package

DESCRIPTION="Combined LaTeX/Metafont package for drawing of Feynman diagrams"
HOMEPAGE="http://www.ctan.org/tex-archive/macros/latex/contrib/feynmf/"
#Taken from: ftp.tug.ctan.org/tex-archive/macros/latex/contrib/${PN}.tar.gz
SRC_URI="mirror://gentoo/${P}.tar.gz
	doc? ( mirror://gentoo/${PN}-cnl.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~ppc ~ppc64 sparc x86 ~x86-fbsd"
IUSE="doc"

DEPEND="|| ( dev-texlive/texlive-metapost app-text/tetex app-text/ptex )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"
TEXMF="/usr/share/texmf-site"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}/${P}.patch"
	epatch "${FILESDIR}/${P}-tempfile.patch"
}

src_compile() {
	export VARTEXFONTS="${T}"/fonts
	emake MP=mpost all manual.ps || die "emake failed"
	if use doc; then
		emake -f Makefile.cnl ps || die "emake fmfcnl failed"
	fi
}

src_install() {
	newbin feynmf.pl feynmf
	doman feynmf.1
	insinto ${TEXMF}/tex/latex/${PN}; doins feynmf.sty feynmp.sty
	insinto ${TEXMF}/metafont/${PN}; doins feynmf.mf
	insinto ${TEXMF}/metapost/${PN}; doins feynmp.mp
	dodoc README manual.ps template.tex
	use doc && dodoc fmfcnl*.ps
}
