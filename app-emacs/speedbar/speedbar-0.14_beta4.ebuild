# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/speedbar/speedbar-0.14_beta4.ebuild,v 1.11 2007/07/04 23:23:33 opfer Exp $

inherit elisp

DESCRIPTION="Allows you to create a special frame with a specialized directory listing in it"
HOMEPAGE="http://cedet.sourceforge.net/speedbar.shtml"
SRC_URI="mirror://sourceforge/cedet/${P/_/}.tar.gz"

LICENSE="GPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=""
RDEPEND="!app-emacs/cedet"

S="${WORKDIR}/${P/_/}"

SITEFILE=50${PN}-gentoo.el

src_compile() {
	emake || die "emake failed"
	emake opt || die "emake opt failed"
}

src_install() {
	elisp-install ${PN} *.el *.elc *.xpm
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	dodoc ChangeLog INSTALL
	doinfo speedbar.info
}
