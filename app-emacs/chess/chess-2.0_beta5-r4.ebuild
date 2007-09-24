# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/chess/chess-2.0_beta5-r4.ebuild,v 1.1 2007/09/24 10:30:11 ulm Exp $

NEED_EMACS=22

inherit elisp eutils

DESCRIPTION="A chess client and library for Emacs"
HOMEPAGE="http://emacs-chess.sourceforge.net/"
SRC_URI="mirror://sourceforge/emacs-chess/${P/_beta/b}.tar.bz2
	mirror://gentoo/emacs-chess-sounds-2.0.tar.bz2
	mirror://gentoo/emacs-chess-pieces-2.0.tar.bz2"

LICENSE="GPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=""
RDEPEND="games-board/gnuchess"

S="${WORKDIR}/${P/_beta/b}"

SITEFILE=51${PN}-gentoo.el
DOCS="ChangeLog EPD.txt PGN.txt PLAN README TODO"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PV}-byte-compiling-files-gentoo.patch" \
		|| die "epatch failed"
	rm -f *.elc
}

# this is needed; elisp.eclass redefines src_compile() from portage default
src_compile() {
	emake || die "emake failed"
}

src_install() {
	elisp_src_install

	doinfo chess.info
	einfo "Installing sound files ..."
	insinto /usr/share/sounds/${PN}
	doins "${WORKDIR}"/sounds/*
	einfo "Installing pixmap files ..."
	insinto /usr/share/pixmaps/${PN}
	doins -r "${WORKDIR}"/pieces/*
}
