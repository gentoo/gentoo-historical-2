# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/extra-syntax/extra-syntax-1.ebuild,v 1.1 2005/02/12 21:10:11 ciaranm Exp $

inherit vim-plugin

DESCRIPTION="vim plugin: metapackage for all extra syntax packages"
HOMEPAGE="http://www.vim.org/"
LICENSE="as-is"
KEYWORDS="~x86 ~sparc"
SRC_URI=""
IUSE=""

RDEPEND="${RDEPEND}
	app-vim/cfengine-syntax
	app-vim/doxygen-syntax
	app-vim/fluxbox-syntax
	app-vim/gentoo-syntax
	app-vim/gtk-syntax
	app-vim/help-extra-syntax
	app-vim/nagios-syntax
	app-vim/selinux-syntax
	app-vim/wikipedia-syntax
	app-vim/xsl-syntax"

src_install() {
	:
}

