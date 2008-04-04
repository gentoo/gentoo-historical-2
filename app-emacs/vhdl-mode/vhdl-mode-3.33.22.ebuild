# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/vhdl-mode/vhdl-mode-3.33.22.ebuild,v 1.4 2008/04/04 23:46:52 josejx Exp $

inherit elisp eutils

DESCRIPTION="VHDL-mode for Emacs"
HOMEPAGE="http://www.iis.ee.ethz.ch/~zimmi/emacs/vhdl-mode.html"
SRC_URI="http://www.iis.ee.ethz.ch/~zimmi/emacs/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

SITEFILE=50${PN}-gentoo.el
DOCS="ChangeLog README"

src_unpack() {
	unpack ${A}
	cd "${S}"
	rm site-start.* || die "rm failed"
	epatch "${FILESDIR}/${PN}-info-dir-gentoo.patch"
}

src_install() {
	elisp_src_install
	doinfo vhdl-mode.info
}
