# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/igrep/igrep-2.93.ebuild,v 1.5 2004/06/15 08:36:32 kloeri Exp $

inherit elisp

IUSE=""

DESCRIPTION='An improved interface to `grep` and `find`.'
HOMEPAGE="ftp://ftp.cis.ohio-state.edu/pub/emacs-lisp/archive/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="virtual/emacs"

SITEFILE=50igrep-gentoo.el

src_compile() {
	emacs --batch -f batch-byte-compile --no-site-file --no-init-file *.el
}

src_install() {
	elisp-install ${PN} *.el *.elc
	elisp-site-file-install ${FILESDIR}/${SITEFILE}
}

pkg_postinst() {
	elisp-site-regen
	einfo "Please see ${SITELISP}/${PN}/igrep.el for the complete documentation."
}

pkg_postrm() {
	elisp-site-regen
}
