# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/redo/redo-1.02.ebuild,v 1.3 2004/06/15 09:58:23 kloeri Exp $

inherit elisp

DESCRIPTION="Redo/undo system for XEmacs (and GNU emacs)"
HOMEPAGE="http://www.wonderworks.com/download/"
SRC_URI="mirror://gentoo/redo-${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND="virtual/emacs"

SITEFILE=50redo-gentoo.el

src_compile() {
	emacs --no-site-file --no-init-file -batch -f batch-byte-compile *.el
}

src_install() {
	elisp-install redo *.el *.elc
	elisp-site-file-install ${FILESDIR}/${SITEFILE}
}
