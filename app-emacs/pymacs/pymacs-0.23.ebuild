# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/pymacs/pymacs-0.23.ebuild,v 1.10 2008/10/27 07:53:27 ulm Exp $

inherit distutils elisp

MY_P=Pymacs-${PV}
DESCRIPTION="A tool that allows both-side communication beetween Python and Emacs Lisp"
HOMEPAGE="http://pymacs.progiciels-bpi.ca/"
SRC_URI="http://pymacs.progiciels-bpi.ca/archives/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ia64 ppc ppc64 s390 sh x86 ~x86-fbsd"
IUSE="doc test"

# additional test? dependency is needed for aeguill.sty (bug 232497)
DEPEND="doc? ( dev-python/docutils virtual/latex-base )
	test? ( || ( dev-texlive/texlive-langfrench
			app-text/tetex
			app-text/ptex ) )"
RDEPEND=""

SITEFILE=50${PN}-gentoo.el

S="${WORKDIR}/${MY_P}"

src_compile() {
	emake || die "emake failed"
	elisp-compile pymacs.el || die "elisp-compile failed"
	if use doc; then
		VARTEXFONTS="${T}"/fonts \
			emake pymacs.pdf || die "emake pymacs.pdf failed"
	fi
}

src_install() {
	elisp_src_install
	distutils_src_install
	dodoc THANKS pymacs.rst
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins pymacs.pdf
	fi
}
