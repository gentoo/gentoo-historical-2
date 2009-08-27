# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/company-mode/company-mode-0.4.3.ebuild,v 1.2 2009/08/27 05:59:22 mr_bones_ Exp $

EAPI=2
NEED_EMACS=22

inherit elisp

DESCRIPTION="In-buffer completion front-end"
HOMEPAGE="http://nschum.de/src/emacs/company-mode/"
SRC_URI="http://nschum.de/src/emacs/${PN}/company-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ropemacs semantic"

# Note: company-mode supports many backends, and we refrain from including
# them all in RDEPEND. Only depend on things that are needed at build time.
DEPEND="semantic? ( app-emacs/cedet )
	|| ( app-emacs/nxml-mode >=virtual/emacs-23 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}"
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	# Disable backends that require extra dependencies, unless they are
	# selected by the respective USE flag
	local backend
	for backend in pysmell ropemacs semantic; do
		has ${backend} ${IUSE} && use ${backend} && continue
		elog "Removing ${backend} backend"
		rm "company-${backend}.el" || die
	done
}
