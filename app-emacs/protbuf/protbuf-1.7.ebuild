# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/protbuf/protbuf-1.7.ebuild,v 1.6 2004/06/24 22:20:46 agriffis Exp $

inherit elisp

IUSE=""

DESCRIPTION="Protect Emacs buffers from accidental killing."
HOMEPAGE="http://www.emacswiki.org/cgi-bin/wiki.pl?ProtectingBuffers"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="virtual/emacs"

SITEFILE=50protbuf-gentoo.el

src_compile() {
	emacs --batch -f batch-byte-compile --no-site-file --no-init-file *.el
}

src_install() {
	elisp-install ${PN} *.el *.elc
	elisp-site-file-install ${FILESDIR}/${SITEFILE}
}

pkg_postinst() {
	elisp-site-regen
	einfo "Please see ${SITELISP}/${PN}/protbuf.el for the complete documentation."
}

pkg_postrm() {
	elisp-site-regen
}
