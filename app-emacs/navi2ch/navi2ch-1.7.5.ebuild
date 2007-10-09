# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/navi2ch/navi2ch-1.7.5.ebuild,v 1.11 2007/10/09 17:42:52 armin76 Exp $

inherit elisp

DESCRIPTION="A navigator for 2ch"
HOMEPAGE="http://navi2ch.sourceforge.net/"
SRC_URI="mirror://sourceforge/navi2ch/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ppc ~ppc64 sparc x86"
IUSE=""

SITEFILE=50${PN}-gentoo.el

src_compile() {
	econf || die
	emake < /dev/null || die
}

src_install() {
	emake < /dev/null \
		DESTDIR="${D}" lispdir=${SITELISP}/navi2ch install || die
	elisp-install navi2ch contrib/*.el || die
	elisp-site-file-install "${FILESDIR}/${SITEFILE}" || die
}

pkg_postinst() {
	elisp-site-regen
	elog
	elog "Please add to your ~/.emacs"
	elog "If you use mona-font,"
	elog "\t(setq navi2ch-mona-enable t)"
	elog "If you use izonmoji-mode,"
	elog "\t(require 'izonmoji-mode)"
	elog "\t(add-hook 'navi2ch-bm-mode-hook	  'izonmoji-mode-on)"
	elog "\t(add-hook 'navi2ch-article-mode-hook 'izonmoji-mode-on)"
	elog "\t(add-hook 'navi2ch-popup-article-mode-hook 'izonmoji-mode-on)"
	elog
}
