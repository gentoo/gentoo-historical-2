# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/locateopen/locateopen-1.3.ebuild,v 1.7 2007/01/12 18:34:33 pioto Exp $

inherit vim-plugin

DESCRIPTION="vim plugin: open a file without supplying a path"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=858"
LICENSE="vim"
KEYWORDS="alpha amd64 ia64 mips ppc sparc x86"
IUSE=""

RDEPEND="${RDEPEND} || ( sys-apps/slocate sys-apps/rlocate )"

VIM_PLUGIN_HELPTEXT=\
"This plugin provides commands that hook vim into slocate:
\    :LocateEdit   filename
\    :LocateSplit  filename
\    :LocateSource filename
\    :LocateRead   filename
To configure:
\    :let g:locateopen_ignorecase = 1    \" enable ignore case mode
\    :let g:locateopen_smartcase = 0     \" disable smart case mode
\    :let g:locateopen_alwaysprompt = 1  \" show menu for one match"
