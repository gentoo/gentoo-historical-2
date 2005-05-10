# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/dircolors/dircolors-1.0.ebuild,v 1.8 2005/05/10 02:59:11 ferringb Exp $

inherit elisp

IUSE=""

DESCRIPTION="Provide the same facility of ls --color inside Emacs"
HOMEPAGE="ftp://ftp.cis.ohio-state.edu/pub/emacs-lisp/archive/"
SRC_URI="mirror://gentoo/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="virtual/emacs"

SITEFILE=50dircolors-gentoo.el

src_compile() {
	emacs --batch -f batch-byte-compile --no-site-file --no-init-file *.el || die
}

src_install() {
	elisp-install ${PN} *.el *.elc
	elisp-site-file-install ${FILESDIR}/${SITEFILE}
}

pkg_postinst() {
	elisp-site-regen
	einfo "Please see ${SITELISP}/${PN}/dircolors.el for the complete documentation."
}

pkg_postrm() {
	elisp-site-regen
}
