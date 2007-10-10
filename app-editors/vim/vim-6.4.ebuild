# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/vim/vim-6.4.ebuild,v 1.13 2007/10/10 07:28:10 opfer Exp $

inherit vim

VIM_VERSION="6.4"
# VIM_ORG_PATCHES="vim-${PV}-patches.tar.bz2"
VIM_GENTOO_PATCHES="vim-${PV}-gentoo-patches.tar.bz2"
# VIM_RUNTIME_SNAP="vim-runtime-20050809.tar.bz2"

SRC_URI="${SRC_URI}
	ftp://ftp.vim.org/pub/vim/unix/vim-${VIM_VERSION}.tar.bz2
	nls? ( ftp://ftp.vim.org/pub/vim/extra/vim-${VIM_VERSION}-lang.tar.gz )
	mirror://gentoo/${VIM_GENTOO_PATCHES}"
#	mirror://gentoo/${VIM_ORG_PATCHES}
#	mirror://gentoo/${VIM_RUNTIME_SNAP}"

S=${WORKDIR}/vim${VIM_VERSION/.}
DESCRIPTION="Vim, an improved vi-style text editor"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sparc x86"
IUSE="nls minimal"
DEPEND="${DEPEND}
	!minimal? ( ~app-editors/vim-core-${PV} )"
RDEPEND="${RDEPEND}
	!minimal? ( ~app-editors/vim-core-${PV} )
	!app-editors/nvi"
