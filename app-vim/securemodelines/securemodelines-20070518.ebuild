# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/securemodelines/securemodelines-20070518.ebuild,v 1.5 2007/06/16 14:28:32 dertobi123 Exp $

VIM_PLUGIN_VIM_VERSION="7.0"
inherit vim-plugin

DESCRIPTION="vim plugin: Secure, user-configurable modeline support."
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=1876"
LICENSE="vim"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"

VIM_PLUGIN_HELPTEXT="Make sure that you disable vim's builtin modeline support if you have
enabled it in your .vimrc.

Documentation is available at:
http://ciaranm.org/tag/securemodelines"
