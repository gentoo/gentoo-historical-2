# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/ctx/ctx-1.17.ebuild,v 1.8 2004/12/21 16:18:55 ciaranm Exp $

inherit vim-plugin

DESCRIPTION="vim plugin: display current scope context in a C file"
HOMEPAGE="http://www.bluweb.com/us/chouser/proj/ctx/"
LICENSE="GPL-2"
KEYWORDS="x86 alpha ia64 ~ppc"
IUSE=""
VIM_PLUGIN_HELPURI="http://www.bluweb.com/us/chouser/proj/ctx/"

# bug #74897
RDEPEND="!app-vim/enhancedcommentify"
