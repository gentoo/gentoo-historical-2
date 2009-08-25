# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/gentoo-syntax/gentoo-syntax-9999.ebuild,v 1.8 2009/08/25 17:02:55 ulm Exp $

inherit elisp subversion

ESVN_REPO_URI="svn://anonsvn.gentoo.org/emacs/${PN}"
DESCRIPTION="Emacs modes for editing ebuilds and other Gentoo specific files"
HOMEPAGE="http://www.gentoo.org/proj/en/lisp/emacs/"
SRC_URI=""

LICENSE="GPL-2 CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE=""

DOCS="ChangeLog"
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp_src_compile
	makeinfo gentoo-syntax.texi
}

src_install() {
	elisp-install ${PN} *.el *.elc || die
	sed -e "s:@PORTDIR@:${PORTDIR}:" \
		"${FILESDIR}/${SITEFILE}" >"${T}/${SITEFILE}" || die
	elisp-site-file-install "${T}/${SITEFILE}" || die
	doinfo gentoo-syntax.info || die
	dodoc ${DOCS} || die
}

pkg_postinst() {
	elisp-site-regen

	elog "Some optional features may require installation of additional"
	elog "packages, like app-portage/gentoolkit-dev for echangelog."
}
