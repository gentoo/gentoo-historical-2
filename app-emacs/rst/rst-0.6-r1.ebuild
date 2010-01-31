# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/rst/rst-0.6-r1.ebuild,v 1.1 2010/01/31 11:14:28 ulm Exp $

EAPI=3

inherit elisp

DESCRIPTION="ReStructuredText support for Emacs"
HOMEPAGE="http://www.emacswiki.org/cgi-bin/wiki/reStructuredText"
SRC_URI="mirror://sourceforge/docutils/docutils-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-macos"
IUSE=""

S="${WORKDIR}/docutils-${PV}/tools/editors/emacs"
DOCS="README.txt"
SITEFILE="50${PN}-gentoo.el"

pkg_setup() {
	local have_emacs=$(elisp-emacs-version)
	if [ "${have_emacs%%.*}" -ge 23 ]; then
		echo
		elog "Please note that \"${PN}\" is already included with Emacs 23 or"
		elog "later, so ${CATEGORY}/${PN} is only needed for lower versions."
		elog "You may select the active Emacs version with \"eselect emacs\"."
	fi
}

src_install() {
	elisp_src_install
	# prevent inclusion of package dir by subdirs.el
	touch "${ED}${SITELISP}/${PN}/.nosearch"
}
