# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/binclock/binclock-1.7.ebuild,v 1.12 2007/01/28 04:03:25 genone Exp $

inherit elisp

IUSE=""

DESCRIPTION="Display the current time using a binary clock."
HOMEPAGE="http://www.davep.org/emacs/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ppc64 x86"

SITEFILE=50binclock-gentoo.el

src_compile() {
	elisp-comp *.el
}

src_install() {
	elisp-install ${PN} *.el *.elc
	elisp-site-file-install ${FILESDIR}/${SITEFILE}
}

pkg_postinst() {
	elisp-site-regen
	elog "Please see ${SITELISP}/${PN}/binclock.el for the complete documentation."
}

pkg_postrm() {
	elisp-site-regen
}
