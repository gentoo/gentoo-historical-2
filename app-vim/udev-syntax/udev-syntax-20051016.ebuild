# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/udev-syntax/udev-syntax-20051016.ebuild,v 1.3 2006/01/26 18:23:09 ticho Exp $

inherit vim-plugin

DESCRIPTION="vim plugin: syntax highlighting for udev rules files"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=1381"
LICENSE="vim"
KEYWORDS="~amd64 ~mips ~sparc ~x86"
IUSE=""

VIM_PLUGIN_HELPTEXT=\
"This plugin provides syntax highlighting for udev.rules files. These files
are automatically detected by filename; manual loading is also possible,
via :set filetype=udev"

