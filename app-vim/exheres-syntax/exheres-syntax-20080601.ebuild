# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/exheres-syntax/exheres-syntax-20080601.ebuild,v 1.2 2008/06/20 21:17:54 coldwind Exp $

inherit vim-plugin

DESCRIPTION="vim plugin: exheres format highlighting"
HOMEPAGE="http://www.exherbo.org/"
SRC_URI="http://dev.exherbo.org/~ahf/pub/software/releases/${PN}/${P}.tar.bz2"

LICENSE="vim"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

VIM_PLUGIN_HELPFILES="exheres-syntax"
VIM_PLUGIN_MESSAGES="filetype"
