# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/ecb/ecb-2.32-r2.ebuild,v 1.4 2007/09/23 14:34:20 nixnut Exp $

inherit elisp

DESCRIPTION="ECB is a source code browser for Emacs"
HOMEPAGE="http://ecb.sourceforge.net/"
SRC_URI="mirror://sourceforge/ecb/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ~x86"
IUSE="java"

DEPEND="app-emacs/cedet
	java? ( app-emacs/jde )"
RDEPEND="${DEPEND}"

SITEFILE=71${PN}-gentoo.el

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e "s%./info-help%../../../info%" \
		-e "s%./html-help%../../../doc/${P}/html%" \
		-e "/defconst/s%ecb.info%ecb.info.gz%" \
		ecb-help.el
}

src_compile() {
	local loadpath=""
	if use java; then
		loadpath="${SITELISP}/elib ${SITELISP}/jde/lisp"
	fi

	emake CEDET="${SITELISP}/cedet" LOADPATH="${loadpath}" \
		|| die "emake failed"
}

src_install() {
	elisp-install ${PN} *.{el,elc}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	insinto "${SITELISP}/${PN}"
	doins -r ecb-images

	dodoc NEWS README RELEASE_NOTES || die "dodoc failed"
	doinfo info-help/ecb.info*
	dohtml html-help/*.html
}

pkg_postinst() {
	elisp-site-regen
	elog "ECB is now autoloaded in site-gentoo.el. Add the line"
	elog "  (require 'ecb)"
	elog "to your ~/.emacs file to enable all features on Emacs startup."
}
