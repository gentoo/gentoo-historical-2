# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/uboat/uboat-1.2.ebuild,v 1.5 2004/06/15 10:07:06 kloeri Exp $

inherit elisp

IUSE=""

DESCRIPTION="Generate u-boat-death messages, patterned after Iron Coffins"
HOMEPAGE="ftp://ftp.splode.com/pub/users/friedman/emacs-lisp/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc"

DEPEND="virtual/emacs"

SITEFILE=50uboat-gentoo.el

src_compile() {
	emacs --batch -f batch-byte-compile --no-site-file --no-init-file *.el
}

src_install() {
	elisp-install ${PN} *.el *.elc
	elisp-site-file-install ${FILESDIR}/${SITEFILE}
}

pkg_postinst() {
	elisp-site-regen
	einfo "Please see ${SITELISP}/${PN}/uboat.el for the complete documentation."
}

pkg_postrm() {
	elisp-site-regen
}
