# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/calendar/calendar-1.4.ebuild,v 1.4 2004/12/11 22:59:22 kloeri Exp $

inherit vim-plugin

DESCRIPTION="vim plugin: calendar window"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=52"
LICENSE="vim"
KEYWORDS="x86 alpha ~ia64 sparc ~ppc ~amd64 ~mips"
IUSE=""

VIM_PLUGIN_HELPTEXT=\
"This plugin provides a calendar window for vim. To start it, use the
:Calendar command."

# bug #62677
RDEPEND="!app-vim/cvscommand"
