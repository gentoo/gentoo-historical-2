# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/semi/semi-1.14.4.ebuild,v 1.4 2003/09/09 08:41:38 msterret Exp $

inherit elisp

IUSE=""

DESCRIPTION="a library to provide MIME feature for GNU Emacs -- SEMI"
HOMEPAGE="http://cvs.m17n.org/elisp/SEMI/index.html.ja.iso-2022-jp"
SRC_URI="ftp://ftp.m17n.org/pub/mule/semi/semi-1.14-for-flim-1.14/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="virtual/emacs
	>=app-emacs/apel-10.3
	>=app-emacs/flim-1.14.4";
#        >=virtual/flim-1.14

PROVIDE="virtual/semi-1.14.4"
S="${WORKDIR}/${P}"

src_compile() {
	make PREFIX=${D}/usr \
		LISPDIR=${D}/${SITELISP} \
		VERSION_SPECIFIC_LISPDIR=${D}/${SITELISP} || die
}

src_install() {
	make PREFIX=${D}/usr \
		LISPDIR=${D}/${SITELISP} \
		VERSION_SPECIFIC_LISPDIR=${D}/${SITELISP} install || die

	elisp-site-file-install ${FILESDIR}/65semi-gentoo.el

	dodoc README* Changelog VERSION NEWS
}

pkg_postinst() {
	elisp-site-regen

	einfo "Please unmerge another version or variatns, if you installed."
	einfo "And you need to rebuild packages depending on ${PN}."
}

pkg_postrm() {
	elisp-site-regen
}
