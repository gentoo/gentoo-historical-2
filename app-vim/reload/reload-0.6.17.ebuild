# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/reload/reload-0.6.17.ebuild,v 1.1 2013/09/01 23:17:10 radhermit Exp $

EAPI=5

inherit vim-plugin vcs-snapshot

DESCRIPTION="vim plugin: automatic reloading of vim scripts"
HOMEPAGE="http://peterodding.com/code/vim/reload/"
SRC_URI="https://github.com/xolox/vim-${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=app-vim/vim-misc-1.8.5"

VIM_PLUGIN_HELPFILES="${PN}.txt"

src_prepare() {
	rm INSTALL.md README.md || die
}
