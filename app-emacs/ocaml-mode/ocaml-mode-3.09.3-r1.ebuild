# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/ocaml-mode/ocaml-mode-3.09.3-r1.ebuild,v 1.4 2007/10/08 13:33:36 opfer Exp $

inherit elisp

MY_P=${P/-mode/}

DESCRIPTION="Emacs mode for OCaml"
HOMEPAGE="http://www.ocaml.org/"
SRC_URI="http://caml.inria.fr/distrib/${MY_P}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

S="${WORKDIR}/${MY_P}/emacs"
SITEFILE=50${PN}-gentoo.el
DOCS="README README.itz"

src_compile() {
	elisp-comp *.el || die "elisp-comp failed"
}
