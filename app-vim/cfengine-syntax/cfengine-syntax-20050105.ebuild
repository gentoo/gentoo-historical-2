# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/cfengine-syntax/cfengine-syntax-20050105.ebuild,v 1.3 2005/02/01 19:32:13 ciaranm Exp $

inherit vim-plugin

DESCRIPTION="vim plugin: Cfengine configuration files syntax"
HOMEPAGE="http://dev.gentoo.org/~ramereth/vim/syntax/cfengine.vim"
LICENSE="as-is"
KEYWORDS="x86 sparc mips ~ppc"
IUSE=""

VIM_PLUGIN_HELPTEXT=\
"This plugin provides syntax highlighting for Cfengine configuration
files. Detection is by filename (/var/cfengine/inputs/)."
