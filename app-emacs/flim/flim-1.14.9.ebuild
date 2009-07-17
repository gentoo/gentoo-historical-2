# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/flim/flim-1.14.9.ebuild,v 1.6 2009/07/17 16:59:46 nixnut Exp $

inherit elisp

DESCRIPTION="A library to provide basic features about message representation or encoding"
HOMEPAGE="http://cvs.m17n.org/elisp/FLIM/"
SRC_URI="http://www.kanji.zinbun.kyoto-u.ac.jp/~tomo/lemi/dist/flim/${P%.*}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc sparc x86"
IUSE=""

DEPEND=">=app-emacs/apel-10.3"
RDEPEND="${DEPEND}
	!app-emacs/limit"

SITEFILE="60${PN}-gentoo.el"

src_compile() {
	emake PREFIX="${D}/usr" \
		LISPDIR="${D}/${SITELISP}" \
		VERSION_SPECIFIC_LISPDIR="${D}/${SITELISP}" || die "emake failed"
}

src_install() {
	emake PREFIX="${D}/usr" \
		LISPDIR="${D}/${SITELISP}" \
		VERSION_SPECIFIC_LISPDIR="${D}/${SITELISP}" install \
		|| die "emake install failed"

	elisp-site-file-install "${FILESDIR}/${SITEFILE}" || die

	dodoc FLIM-API.en NEWS VERSION README* ChangeLog || die "dodoc failed"
}
