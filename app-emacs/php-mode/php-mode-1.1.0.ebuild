# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/php-mode/php-mode-1.1.0.ebuild,v 1.1 2004/05/22 16:17:50 usata Exp $

inherit elisp

IUSE=""

DESCRIPTION="GNU Emacs major mode for editing PHP code"
HOMEPAGE="http://php-mode.sourceforge.net"
SRC_URI="mirror://sourceforge/php-mode/${P}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"

DEPEND="virtual/emacs"

S="${WORKDIR}"

SITEFILE=50php-mode-gentoo.el

src_compile() {
	emacs --batch -f batch-byte-compile --no-site-file --no-init-file *.el
}

src_install() {
	elisp-install ${PN} *.el *.elc
	elisp-site-file-install ${FILESDIR}/${SITEFILE}
}
