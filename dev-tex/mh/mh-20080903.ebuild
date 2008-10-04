# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/mh/mh-20080903.ebuild,v 1.6 2008/10/04 01:43:27 ranger Exp $

inherit latex-package

DESCRIPTION="Additional LaTeX math tools."
HOMEPAGE="http://www.ctan.org/tex-archive/macros/latex/contrib/mh/"
SRC_URI="mirror://gentoo/${P}.zip"
LICENSE="LPPL-1.3"
SLOT="0"
IUSE="doc"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

RDEPEND="!dev-tex/breqn
	dev-tex/xcolor
	>=dev-texlive/texlive-latex3-2008"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/${PN}
TEXMF=/usr/share/texmf-site

src_compile() {
	# To avoid sandbox violations
	export VARTEXFONTS="${T}/fonts"

	# Unpacking *.dtx
	for i in *.dtx; do
		tex ${i} || die "TeXing ${i} failed"
	done

	latex-package_src_compile
}

src_install() {
	latex-package_src_doinstall styles fonts bin

	insinto "${TEXMF}/tex/latex/${PN}"
	doins *.sym

	use doc && latex-package_src_doinstall doc
	dodoc README
}
