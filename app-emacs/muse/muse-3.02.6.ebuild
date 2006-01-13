# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/muse/muse-3.02.6.ebuild,v 1.1 2006/01/13 08:53:35 wrobel Exp $

inherit elisp

IUSE=""

DESCRIPTION="Muse-mode is similar to EmacsWikiMode, but more focused on publishing to various formats."
HOMEPAGE="http://www.mwolson.org/projects/MuseMode.html"
SRC_URI="http://download.gna.org/muse-el/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

DEPEND="virtual/emacs"

SITEFILE=50muse-mode-gentoo.el

S="${WORKDIR}/${P}"

src_compile() {
	make lisp || die
}

src_install() {
	dodoc README
	cp -r examples contrib experimental scripts ${D}/usr/share/doc/${PF}/
	elisp-install ${PN} lisp/*.el lisp/*.elc
	elisp-site-file-install ${FILESDIR}/${SITEFILE}
}

pkg_postinst() {
	elisp-site-regen
	einfo "Please see ${SITELISP}/${PN}/muse-mode.el for the complete documentation."
}

pkg_postrm() {
	elisp-site-regen
}
