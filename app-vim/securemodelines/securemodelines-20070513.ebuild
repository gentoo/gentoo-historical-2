# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/securemodelines/securemodelines-20070513.ebuild,v 1.6 2007/05/16 05:15:08 jer Exp $

VIM_PLUGIN_VIM_VERSION="7.0"
inherit vim-plugin

DESCRIPTION="vim plugin: Secure, user-configurable modeline support."
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=1876"
LICENSE="vim"
KEYWORDS="~amd64 ~hppa ~ia64 ~sparc ~x86 ~x86-fbsd"

VIM_PLUGIN_HELPTEXT="Make sure that you disable vim's builtin modeline support if you have
enabled it in your .vimrc.

Documentation is available at:
http://ciaranm.org/tag/securemodelines"
