# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/casting-spels-emacs/casting-spels-emacs-19.ebuild,v 1.2 2008/08/11 11:15:25 ulm Exp $

inherit elisp-common eutils

DESCRIPTION="Casting SPELs in Lisp - A Comic Book (Emacs Lisp Edition)"
HOMEPAGE="http://code.google.com/p/casting-spels-emacs/"
SRC_URI="http://casting-spels-emacs.googlecode.com/files/${PN}-v${PV}.zip"

LICENSE="GPL-2 FDL-1.2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="virtual/emacs"
DEPEND="app-arch/unzip"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	edos2unix *.txt html/*.html {lisp,test}/*.el || die "edos2unix failed"
}

src_install() {
	elisp-install ${PN} lisp/*.el || die "elisp-install failed"
	dohtml -r html/. images || die "dohtml failed"
	dosym html/images /usr/share/doc/${PF}/images
	dosym ${SITELISP}/${PN} /usr/share/doc/${PF}/lisp
	dodoc README.txt test/walk-through-commands.el
}
