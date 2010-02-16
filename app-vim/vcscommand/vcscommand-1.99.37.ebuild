# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/vcscommand/vcscommand-1.99.37.ebuild,v 1.1 2010/02/16 16:03:53 lack Exp $

VIM_PLUGIN_VIM_VERSION="7.0"
inherit vim-plugin

DESCRIPTION="vim plugin: CVS/SVN/SVK/git/bzr/hg integration plugin"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=90"

LICENSE="public-domain"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

RDEPEND="!app-vim/cvscommand
	!app-vim/calendar" # conflict, bug 62677

VIM_PLUGIN_HELPFILES="vcscommand"
