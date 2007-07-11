# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/dbext/dbext-2.10.ebuild,v 1.5 2007/07/11 05:14:08 mr_bones_ Exp $

inherit vim-plugin eutils

DESCRIPTION="vim plugin: easy access to databases"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=356"
LICENSE="as-is"
KEYWORDS="x86 sparc mips ~ppc"
IUSE=""

RDEPEND=">=app-vim/multvals-3.6.1
	>=app-vim/genutils-1.13"

VIM_PLUGIN_HELPFILES="dbext"

src_unpack() {
	unpack ${A}
	cd ${S}
	edos2unix {plugin,doc}/*
}
