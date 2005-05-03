# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/gnuserv/gnuserv-3.12.7.ebuild,v 1.2 2005/05/03 11:01:57 usata Exp $

inherit elisp

DESCRIPTION="attach to an already running Emacs"
HOMEPAGE="http://meltin.net/hacks/emacs/"
SRC_URI="http://meltin.net/hacks/emacs/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="virtual/libc
	virtual/emacs"

SITEFILE=50gnuserv-gentoo.el

src_compile() {
	# bug #83112
	unset LDFLAGS

	econf || die
	emake || die
}

src_install() {
	dodir /usr/share/man/man1
	einstall man1dir=${D}/usr/share/man/man1 || die

	elisp-install ${PN} *.el *.elc
	elisp-site-file-install ${FILESDIR}/${SITEFILE}

	dodoc ChangeLog INSTALL README README.orig
}
