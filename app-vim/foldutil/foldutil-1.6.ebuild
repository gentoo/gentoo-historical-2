# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/foldutil/foldutil-1.6.ebuild,v 1.4 2004/09/03 02:38:35 ciaranm Exp $

inherit vim-plugin

DESCRIPTION="vim plugin: fold creation utility"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=158"
LICENSE="GPL-2"
KEYWORDS="x86 sparc mips ~ppc"
IUSE=""

RDEPEND="
	|| ( >=app-editors/vim-6.3 >=app-editors/gvim-6.3 )
	>=app-vim/multvals-3.6.1"

VIM_PLUGIN_HELPTEXT=\
"This plugin provides a number of commands for working with folds:
\    :FoldNonMatching [pattern] [context]
\    :FoldShowLines   {lines} [context]
\    :FoldEndFolding"
