# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/howm/howm-1.3.4-r1.ebuild,v 1.3 2007/12/01 00:04:51 opfer Exp $

inherit elisp

DESCRIPTION="Note-taking tool on Emacs"
HOMEPAGE="http://howm.sourceforge.jp/"
SRC_URI="http://howm.sourceforge.jp/a/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

SITEFILE=50${PN}-gentoo.el

src_compile() {
	econf --with-docdir=/usr/share/doc/${PF} || die "econf failed"
	emake -j1 < /dev/null || die "emake failed"
}

src_install() {
	emake -j1 < /dev/null \
		DESTDIR="${D}" PREFIX=/usr LISPDIR="${SITELISP}/${PN}" install \
		|| die "emake install failed"
	elisp-site-file-install "${FILESDIR}/${SITEFILE}" \
		|| die "elisp-site-file-install failed"
	dodoc ChangeLog || die "dodoc failed"
}

pkg_postinst() {
	elisp-site-regen
	elog "site-gentoo.el does no longer define global keybindings for howm."
	elog "Add the following line to ~/.emacs for the previous behaviour:"
	elog "  (require 'howm)"
}
