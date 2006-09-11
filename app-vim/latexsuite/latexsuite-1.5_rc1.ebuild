# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/latexsuite/latexsuite-1.5_rc1.ebuild,v 1.12 2006/09/11 01:08:57 wormo Exp $

inherit vim-plugin

DESCRIPTION="vim plugin: Latex-Suite attempts to provide a comprehensive set of tools to view, edit and compile LaTeX documents in Vim."
HOMEPAGE="http://vim-latex.sourceforge.net/"
LICENSE="vim"
KEYWORDS="alpha sparc ~x86 ia64 ~ppc ~amd64"
IUSE=""

# We use this tar-ball as it's distributed instead of repackaging it.
# The only caveat is that the tarball unpacks into the current
# directory instead of including a top-level directory.
MY_P="latexSuite-${PV/_/-}"
S="${WORKDIR}"
SRC_URI="http://vim-latex.sourceforge.net/download/${MY_P}.tar.gz"

RDEPEND="virtual/tetex"

src_install() {
	into /usr ; dobin ltags ; rm ltags
	vim-plugin_src_install
}

pkg_postinst() {
	vim-plugin_pkg_postinst
	einfo
	einfo "To use the latexSuite plugin add:"
	einfo "   filetype plugin on"
	einfo '   set grepprg=grep\ -nH\ $*'
	einfo "to your ~/.vimrc-file"
	einfo
	einfo "Help for this plugin is available with ':help latex-suite' in vim"
	einfo
}
