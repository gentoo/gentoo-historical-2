# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/ess/ess-5.3.8.ebuild,v 1.3 2008/12/08 15:48:05 armin76 Exp $

inherit elisp

DESCRIPTION="Emacs Speaks Statistics"
HOMEPAGE="http://ess.r-project.org/"
SRC_URI="http://ess.r-project.org/downloads/ess/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ~ppc sparc x86"
IUSE=""

DEPEND="app-text/texi2html
	virtual/latex-base"
RDEPEND=""

SITEFILE=50${PN}-gentoo.el

src_compile() {
	emake PREFIX=/usr \
		INFODIR=/usr/share/info \
		LISPDIR="${SITELISP}"/ess \
		|| die "emake failed"
}

src_install() {
	# Install all elisp sources; the Makefile installs only part of them.
	# This has to go before emake install, see bug 205156 comment 3.
	elisp-install ${PN} lisp/ess*.el || die

	emake PREFIX="${D}/usr" \
		INFODIR="${D}/usr/share/info" \
		LISPDIR="${D}${SITELISP}/ess" \
		install || die "emake install failed"

	elisp-site-file-install "${FILESDIR}/${SITEFILE}" || die
	#insinto "${SITEETC}/ess"
	#doins -r etc/*

	dohtml doc/html/*.html
	dodoc ANNOUNCE ChangeLog doc/{NEWS,README,TODO} || die "dodoc failed"
	newdoc lisp/ChangeLog ChangeLog-lisp || die "newdoc failed"
	insinto /usr/share/doc/${PF}
	doins doc/ess-intro.pdf || die "doins failed"
}

pkg_postinst() {
	elisp-site-regen
	elog "Please see /usr/share/doc/${PF} for the complete documentation."
	elog "Usage hints are in ${SITELISP}/${PN}/ess-site.el ."
}
