# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/tuareg-mode/tuareg-mode-1.40.5.ebuild,v 1.1 2003/10/28 07:36:39 usata Exp $

inherit elisp

DESCRIPTION="OCaml mode for emacs"
HOMEPAGE="http://www-rocq.inria.fr/~acohen/tuareg/index.html.en"
SRC_URI="http://www-rocq.inria.fr/~acohen/tuareg/mode/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
DEPEND=">=app-editors/emacs-21.0"

S="${WORKDIR}/${P}"

SITEFILE=50tuareg-mode.el

src_compile () {
	einfo "Byte-code compilation not supported"
}

src_install() {
	elisp-install ${PN} camldebug.el tuareg.el
	elisp-site-file-install ${FILESDIR}/${SITEFILE}
	dodoc HISTORY COPYING LISEZMOI README
}

pkg_postinst() {
	elisp-site-regen
}

pkg_postrm() {
	elisp-site-regen
}
