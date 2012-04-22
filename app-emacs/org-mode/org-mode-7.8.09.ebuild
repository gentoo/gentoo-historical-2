# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/org-mode/org-mode-7.8.09.ebuild,v 1.1 2012/04/22 19:51:51 ulm Exp $

EAPI=4
NEED_EMACS=22

inherit elisp

DESCRIPTION="An Emacs mode for notes and project planning"
HOMEPAGE="http://www.orgmode.org/"
SRC_URI="http://orgmode.org/org-${PV}.tar.gz"

LICENSE="GPL-3 FDL-1.3 contrib? ( GPL-2 MIT as-is )"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~sparc-fbsd ~x86-fbsd ~x86-macos"
IUSE="contrib"

S="${WORKDIR}/org-${PV}"
ELISP_PATCHES="${PN}-7.8.03-Makefile.patch"
# Remove autoload file to make sure that it is regenerated with
# the right Emacs version.
ELISP_REMOVE="lisp/org-install.el"
SITEFILE="50${PN}-gentoo-7.8.03.el"

src_compile() {
	emake datadir="${SITEETC}/${PN}"
}

src_install() {
	emake \
		prefix="${ED}/usr" \
		lispdir="${ED}${SITELISP}/${PN}" \
		datadir="${ED}${SITEETC}/${PN}" \
		infodir="${ED}/usr/share/info" \
		install

	cp "${FILESDIR}/${SITEFILE}" "${T}/${SITEFILE}"

	if use contrib; then
		elisp-install ${PN}/contrib contrib/lisp/*org*.el || die
		insinto /usr/share/doc/${PF}/contrib
		doins -r contrib/README contrib/babel contrib/odt contrib/scripts
		find "${ED}/usr/share/doc/${PF}/contrib" -type f -name '.*' \
			-exec rm -f '{}' '+'
		# add the contrib subdirectory to load-path
		sed -ie 's:\(.*@SITELISP@\)\(.*\):&\n\1/contrib\2:' \
			"${T}/${SITEFILE}" || die
	fi

	elisp-site-file-install "${T}/${SITEFILE}" || die
	doinfo doc/org
	dodoc README doc/org.pdf doc/orgcard.pdf doc/orgguide.pdf
}
