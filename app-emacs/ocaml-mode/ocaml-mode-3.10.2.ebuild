# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/ocaml-mode/ocaml-mode-3.10.2.ebuild,v 1.5 2008/06/22 18:10:23 armin76 Exp $

inherit elisp

MY_P=${P/-mode/}

DESCRIPTION="Emacs mode for OCaml"
HOMEPAGE="http://www.ocaml.org/"
SRC_URI="http://caml.inria.fr/distrib/${MY_P%.*}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

S="${WORKDIR}/${MY_P}/emacs"
SITEFILE=50${PN}-gentoo.el
DOCS="README README.itz"

src_compile() {
	elisp-comp *.el || die "elisp-comp failed"
}
