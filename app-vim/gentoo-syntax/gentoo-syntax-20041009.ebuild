# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/gentoo-syntax/gentoo-syntax-20041009.ebuild,v 1.4 2004/11/09 01:28:39 dostrow Exp $

inherit vim-plugin

DESCRIPTION="vim plugin: Gentoo Ebuild, Eclass, GLEP, ChangeLog and Portage
Files syntax highlighting, filetype and indent settings"
HOMEPAGE="http://developer.berlios.de/projects/gentoo-syntax"
LICENSE="vim"
KEYWORDS="x86 sparc mips amd64 ~ppc ~ppc64"
IUSE=""
RESTRICT="nomirror"
SRC_URI="http://download.berlios.de/gentoo-syntax/${P}.tar.bz2"

VIM_PLUGIN_HELPFILES="gentoo-syntax"

