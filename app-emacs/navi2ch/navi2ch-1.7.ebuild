# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/navi2ch/navi2ch-1.7.ebuild,v 1.3 2003/09/30 13:23:06 usata Exp $

inherit elisp

IUSE=""

DESCRIPTION="Navi2ch is navigator for 2ch which works under many Emacsen"
HOMEPAGE="http://navi2ch.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 alpha ppc sparc"

DEPEND="virtual/emacs
	dev-lisp/mule-ucs"

S=${WORKDIR}/${P}
SITEFILE=50navi2ch-gentoo.el

src_compile() {

	econf || die
	emake < /dev/null || die
}

src_install() {

	emake < /dev/null \
		DESTDIR=${D} lispdir=${SITELISP}/navi2ch install || die
	elisp-install navi2ch contrib/*.el || die
	elisp-site-file-install ${FILESDIR}/${SITEFILE} || die
}

pkg_postinst() {

	elisp-site-regen
	einfo ""
	einfo "Please add to your .emacs"
	einfo "If you use mona-font,"
	einfo "\t(setq navi2ch-mona-enable t)"
	einfo "If you use izonmoji-mode,"
	einfo "\t(require 'un-define)"
	einfo "\t(require 'izonmoji-mode)"
	einfo "\t(add-hook 'navi2ch-bm-mode-hook      'izonmoji-mode-on)"
	einfo "\t(add-hook 'navi2ch-article-mode-hook 'izonmoji-mode-on)"
	einfo "\t(add-hook 'navi2ch-popup-article-mode-hook 'izonmoji-mode-on)"
	einfo ""
}

pkg_postrm() {

	elisp-site-regen
}
