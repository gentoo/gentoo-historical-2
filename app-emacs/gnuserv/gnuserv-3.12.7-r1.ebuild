# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/gnuserv/gnuserv-3.12.7-r1.ebuild,v 1.2 2007/06/16 13:23:32 dertobi123 Exp $

inherit elisp eutils

DESCRIPTION="Attach to an already running Emacs"
HOMEPAGE="http://meltin.net/hacks/emacs/"
SRC_URI="http://meltin.net/hacks/emacs/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

DEPEND=""
RDEPEND="|| ( ~app-emacs/gnuserv-programs-${PV} virtual/xemacs )"

SITEFILE=50${PN}-gentoo.el

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-path-xemacs.patch"
}

src_compile() {
	elisp-comp *.el || die "elisp-comp failed"
}

src_install() {
	elisp-install ${PN} *.el *.elc
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	dodoc ChangeLog README README.orig || die "dodoc failed"
}
