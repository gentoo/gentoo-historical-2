# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/ecb/ecb-2.24.ebuild,v 1.6 2004/09/23 05:30:24 usata Exp $

inherit elisp

DESCRIPTION="ECB is a source code browser for Emacs"
HOMEPAGE="http://ecb.sourceforge.net/"
SRC_URI="mirror://sourceforge/ecb/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~amd64"
IUSE="java"
DEPEND="virtual/emacs
	|| (
		( >=app-emacs/speedbar-0.14_beta4
		>=app-emacs/semantic-1.4
		>=app-emacs/eieio-0.17
		)
		app-emacs/cedet
	)
	java? ( app-emacs/jde )"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i -e "s%./info-help%../../../info%" \
		-e "s%./html-help%../../../doc/${P}/html%" \
		-e "/defconst/s%ecb.info%ecb.info.gz%" \
		ecb-help.el
}

src_compile() {
	local my_loadpath="${SITELISP}/semantic ${SITELISP}/eieio"
	use java \
		&& my_loadpath="${my_loadpath} ${SITELISP}/elib ${SITELISP}/jde/lisp"
	make CEDET='' \
		LOADPATH="${my_loadpath}" \
		|| die
	make online-help \
		LOADPATH="${my_loadpath}" \
		|| die
}

src_install() {
	elisp-install ${PN} *.el *.elc
	elisp-site-file-install ${FILESDIR}/70ecb-gentoo.el
	dodoc NEWS README RELEASE_NOTES
	doinfo info-help/ecb.info*
	dohtml html-help/*.html
}
