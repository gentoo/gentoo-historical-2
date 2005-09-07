# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/doxygen-syntax/doxygen-syntax-1.12.ebuild,v 1.3 2005/09/07 16:03:58 corsair Exp $

inherit vim-plugin

DESCRIPTION="vim plugin: syntax higlighting for doxygen"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=5"
LICENSE="as-is"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 mips ~ppc ppc64 sparc x86"
IUSE=""

VIM_PLUGIN_HELPFILES="doxygen.vim"

src_unpack() {
	unpack ${A}
	cd ${S}
	# make this work with the screwy vim7-supplied synload.vim, and fix the
	# bug which causes it to try to use b:current_syntax when it's unset.
	sed -e "/^let s:cpo_save/iif ! exists('b:current_syntax') | \
let b:current_syntax='' | endif" \
		-e "s/^if !exists('b:current_syntax')$/& || b:current_syntax == ''/" \
		-e '1iau! Syntax cpp,c,idl' \
		-e '1iau! Syntax *doxygen' \
		-i syntax/doxygen.vim || \
		die "sed failed"
}

