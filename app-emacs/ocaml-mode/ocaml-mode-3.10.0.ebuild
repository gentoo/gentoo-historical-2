# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/ocaml-mode/ocaml-mode-3.10.0.ebuild,v 1.3 2007/10/23 11:23:46 armin76 Exp $

inherit elisp

MY_P=${P/-mode/}

DESCRIPTION="Emacs mode for OCaml"
HOMEPAGE="http://www.ocaml.org/"
# because versioning scheme is not consistent
SRC_URI="http://caml.inria.fr/distrib/${MY_P/\.0/}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE=""

S="${WORKDIR}/${MY_P}/emacs"
SITEFILE=50${PN}-gentoo.el
DOCS="README README.itz"

src_compile() {
	elisp-comp *.el || die "elisp-comp failed"
}
