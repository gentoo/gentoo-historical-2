# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/eieio/eieio-0.17.ebuild,v 1.2 2003/02/13 07:05:03 vapier Exp $

inherit elisp

IUSE=""

DESCRIPTION="Enhanced Integration of Emacs Interpreted Objects"
HOMEPAGE="http://cedet.sourceforge.net/eieio.shtml"
SRC_URI="mirror://sourceforge/cedet/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="virtual/emacs
	app-emacs/speedbar"

S="${WORKDIR}/${P}"

SITEFILE=60eieio-gentoo.el

src_compile() {
	make LOADPATH=${SITELISP}/speedbar || die
}

src_install() {
	elisp-install ${PN} *.el *.elc
	elisp-site-file-install ${FILESDIR}/${SITEFILE}

	dodoc ChangeLog INSTALL
	doinfo eieio.info
}

pkg_postinst() {
	elisp-site-regen
}

pkg_postrm() {
	elisp-site-regen
}
