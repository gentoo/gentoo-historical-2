# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/align/align-42.ebuild,v 1.5 2012/12/17 17:49:40 ago Exp $

EAPI=4

inherit vim-plugin

DESCRIPTION="vim plugin: commands and maps to help produce aligned text"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=294"
LICENSE="vim"
KEYWORDS="~alpha amd64 ia64 ~mips ppc ~sparc x86"
IUSE=""
RDEPEND="app-vim/cecutil"

VIM_PLUGIN_HELPFILES="align"
