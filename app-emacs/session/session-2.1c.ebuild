# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/session/session-2.1c.ebuild,v 1.1 2002/11/01 02:52:01 mkennedy Exp $

inherit elisp 

IUSE=""

DESCRIPTION="When you start Emacs, Session restores various variables from your last session."
HOMEPAGE="http://emacs-session.sourceforge.net/index.html"
SRC_URI="mirror://sourceforge/emacs-session/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="virtual/emacs"

S="${WORKDIR}/${PN}"

src_compile() {
	cd lisp
	emacs -batch -eval "(byte-compile-file \"session.el\")" || die
}

src_install() {
	elisp-install ${PN} lisp/*.el lisp/*.elc 
	elisp-site-file-install ${FILESDIR}/50session-gentoo.el
	dodoc INSTALL README lisp/ChangeLog
}

pkg_postinst() {
	elisp-site-regen
	einfo "Add the folloing to your ~/.emacs to use session:"
	einfo "	(require 'session)"
	einfo "	(add-hook 'after-init-hook 'session-initialize)"
}

pkg_postrm() {
	elisp-site-regen
}
