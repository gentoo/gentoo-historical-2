# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/chess/chess-2.0_beta5-r2.ebuild,v 1.3 2007/04/07 16:41:45 opfer Exp $

inherit elisp-common eutils

DESCRIPTION="A chess client and library for Emacs"
HOMEPAGE="http://emacs-chess.sourceforge.net/"
SRC_URI="mirror://sourceforge/emacs-chess/${P/_beta/b}.tar.bz2
	mirror://gentoo/emacs-chess-sounds-2.0.tar.bz2
	mirror://gentoo/emacs-chess-pieces-2.0.tar.bz2"

LICENSE="GPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="festival"

# don't forget to change it back to virtual/emacs
# (inherit elisp.eclass)!  See bug 151474
DEPEND="app-editors/emacs-cvs"

RDEPEND="${DEPEND}
	games-board/gnuchess
	festival? ( app-accessibility/festival ) "

S="${WORKDIR}/${P/_beta/b}"

SITEFILE=51chess-gentoo.el

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}/${PV}-byte-compiling-files-gentoo.patch" || die "epatch failed"
	cd "${S}" && rm -f *.elc
}

src_compile() {
	make || die
}

src_install() {
	elisp-install ${PN} *.el *.elc
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	dodir /usr/share/pixmaps/${PN}
	cp -r "${WORKDIR}/pieces/." "${D}/usr/share/pixmaps/${PN}"
	dodir /usr/share/sounds/${PN}
	cp -r "${WORKDIR}/sounds/." "${D}/usr/share/sounds/${PN}"

	doinfo chess.info
	dohtml *.html
	dodoc ChangeLog EPD.txt PGN.txt PLAN README TODO
}
