# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/slimv/slimv-0.9.0.ebuild,v 1.1 2011/10/10 08:31:14 radhermit Exp $

EAPI=4

inherit vim-plugin

DESCRIPTION="vim plugin: aid Lisp development by providing a SLIME-like Lisp and Clojure REPL"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=2531"
SRC_URI="https://github.com/vim-scripts/${PN}.vim/tarball/${PV} -> ${P}.tar.gz"
LICENSE="public-domain"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="|| ( app-editors/vim[python] app-editors/gvim[python] )
	>=dev-lang/python-2.4
	|| (
		dev-lisp/clisp
		dev-lang/clojure
		dev-lisp/abcl
		dev-lisp/clozurecl
		dev-lisp/ecls
		dev-lisp/sbcl
	)"

VIM_PLUGIN_HELPFILES="slimv.txt"

src_unpack() {
	unpack ${A}
	mv *-${PN}.vim-* "${S}"
}

src_prepare() {
	# Remove emacs related files
	rm -rf slime swank-clojure

	rm README
}
