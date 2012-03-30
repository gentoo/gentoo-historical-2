# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/utop/utop-1.1.ebuild,v 1.1 2012/03/30 11:52:39 aballier Exp $

EAPI=4

OASIS_BUILD_DOCS=1
inherit oasis elisp-common

DESCRIPTION="A new toplevel for OCaml with completion and colorization"
HOMEPAGE="http://forge.ocamlcore.org/projects/utop/"
SRC_URI="http://forge.ocamlcore.org/frs/download.php/674/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="emacs"

DEPEND="dev-ml/lwt[react]
	dev-ml/lambda-term
	dev-ml/zed
	emacs? ( virtual/emacs )"
RDEPEND="${DEPEND}"

DOCS=( "CHANGES" "README" )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	sed -i "s/(\"utop.el.*)//" setup.ml
}

src_compile() {
	oasis_src_compile
	if use emacs; then
		elisp-compile src/*.el
	fi
}

src_install() {
	oasis_src_install
	if use emacs; then
		elisp-install "${PN}" src/*.el src/*.elc || die
		elisp-site-file-install "${FILESDIR}/${SITEFILE}" || die
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
