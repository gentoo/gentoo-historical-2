# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/ruby-mode/ruby-mode-1.8.0.ebuild,v 1.4 2004/06/24 22:22:45 agriffis Exp $

inherit elisp

DESCRIPTION="Emacs major mode for editing Ruby code"
HOMEPAGE="http://www.ruby-lang.org/"
SRC_URI="mirror://ruby/ruby-${PV}.tar.gz"

SLOT="0"
IUSE=""
KEYWORDS="x86"
LICENSE="GPL-2"
DEPEND="virtual/emacs"

SITEFILE=50ruby-mode-gentoo.el

S="${WORKDIR}/ruby-${PV}/misc"

src_compile() {
	emacs --no-site-file --no-init-file -batch -f batch-byte-compile *.el
}

src_install() {
	elisp-install ruby-mode *.el *.elc
	elisp-site-file-install ${FILESDIR}/${SITEFILE}
}
