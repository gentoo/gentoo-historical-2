# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/taglist/taglist-2.6.ebuild,v 1.1 2003/07/31 13:01:12 agriffis Exp $

inherit vim-plugin

DESCRIPTION="vim plugin: ctags-based source code browser"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=273"
LICENSE="vim"
KEYWORDS="~x86 ~alpha"
RDEPEND="${RDEPEND} dev-util/ctags"
