# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/errsign/errsign-0.1.ebuild,v 1.3 2005/01/01 16:49:28 eradicator Exp $

inherit vim-plugin

DESCRIPTION="vim plugin: display marks on lines with errors"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=1027"

LICENSE="as-is"
KEYWORDS="sparc mips x86"
IUSE=""

VIM_PLUGIN_HELPTEXT=\
'To use this plugin, simply type \\\\es in normal mode and any lines which
have been marked as errors (for example, via :make) will be indicated with
a >> mark on the left of the window.'
