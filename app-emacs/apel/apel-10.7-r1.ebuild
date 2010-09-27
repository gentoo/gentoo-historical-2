# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/apel/apel-10.7-r1.ebuild,v 1.8 2010/09/27 11:00:40 xmw Exp $

EAPI=3

inherit elisp

DESCRIPTION="A Portable Emacs Library is a library for making portable Emacs Lisp programs."
HOMEPAGE="http://cvs.m17n.org/elisp/APEL/"
SRC_URI="ftp://ftp.jpl.org/pub/elisp/apel/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

src_prepare() {
	cat <<-EOF >> APEL-CFG
	(setq APEL_PREFIX "apel")
	(setq EMU_PREFIX "apel")
	EOF
}

src_compile() {
	emake PREFIX="${ED}/usr" \
		LISPDIR="${ED}/${SITELISP}" \
		VERSION_SPECIFIC_LISPDIR="${ED}/${SITELISP}" || die "emake failed"
}

src_install() {
	einstall PREFIX="${ED}/usr" \
		LISPDIR="${ED}/${SITELISP}" \
		VERSION_SPECIFIC_LISPDIR="${ED}/${SITELISP}" || die "einstall failed"

	elisp-site-file-install "${FILESDIR}/50apel-gentoo.el"

	dodoc ChangeLog README*
}

pkg_postinst() {
	elisp-site-regen

	elog "See the README.en file in /usr/share/doc/${PF} for tips"
	elog "on how to customize this package."
	elog "And you need to rebuild packages depending on ${PN}."
}
