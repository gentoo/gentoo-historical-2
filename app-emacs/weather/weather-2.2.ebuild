# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/weather/weather-2.2.ebuild,v 1.7 2005/01/01 14:06:29 eradicator Exp $

inherit elisp

IUSE=""

# This probably needs some work (wm broken?)

DESCRIPTION="Quickly grab a temperature from the net."
HOMEPAGE="ftp://ftp.cis.ohio-state.edu/pub/emacs-lisp/archive/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="virtual/emacs
	app-emacs/w3"

SITEFILE=50weather-gentoo.el

src_compile() {
	emacs --batch -f batch-byte-compile --no-site-file --no-init-file *.el
}

src_install() {
	elisp-install ${PN} *.el *.elc
	elisp-site-file-install ${FILESDIR}/${SITEFILE}
}

pkg_postinst() {
	elisp-site-regen
	einfo "Please see ${SITELISP}/${PN}/weather.el for the complete documentation."
}

pkg_postrm() {
	elisp-site-regen
}
