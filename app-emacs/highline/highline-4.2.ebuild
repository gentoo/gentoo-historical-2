# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/highline/highline-4.2.ebuild,v 1.1 2003/03/06 06:57:36 mkennedy Exp $

inherit elisp

IUSE=""

DESCRIPTION="Minor mode to highlight current line in buffer"
HOMEPAGE="http://www.cpqd.br/~vinicius/emacs/Emacs.html"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="virtual/emacs"

S="${WORKDIR}/${P}"

SITEFILE=50highline-gentoo.el

src_compile() {
	emacs --batch -f batch-byte-compile --no-site-file --no-init-file *.el
}

src_install() {
	elisp-install ${PN} *.el *.elc
	elisp-site-file-install ${FILESDIR}/${SITEFILE}
}

pkg_postinst() {
	elisp-site-regen
	einfo "Please see ${SITELISP}/${PN}/highline.el for the complete documentation."
}

pkg_postrm() {
	elisp-site-regen
}
