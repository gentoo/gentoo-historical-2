# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/semantic/semantic-1.4.4.ebuild,v 1.5 2004/06/24 22:22:55 agriffis Exp $

inherit elisp

IUSE=""

DESCRIPTION="The Semantic Bovinator is a lexer, parser-generator, and parser written in Emacs Lisp"
HOMEPAGE="http://cedet.sourceforge.net/semantic.shtml"
SRC_URI="mirror://sourceforge/cedet/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="virtual/emacs
	>=app-emacs/speedbar-0.14_beta4
	>=app-emacs/eieio-0.17"

src_compile() {
	make LOADPATH="${SITELISP}/speedbar ${SITELISP}/eieio" || die
}

src_install() {
	elisp-install ${PN} *.el *.elc *.bnf
	elisp-site-file-install ${FILESDIR}/60semantic-gentoo.el
	dodoc ChangeLog NEWS INSTALL
	doinfo semantic.info*
}
