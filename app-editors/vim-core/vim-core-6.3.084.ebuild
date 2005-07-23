# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/vim-core/vim-core-6.3.084.ebuild,v 1.9 2005/07/23 21:59:06 hardave Exp $

inherit vim

VIM_VERSION="6.3"
VIM_ORG_PATCHES="vim-${PV}-patches.tar.bz2"
VIM_RUNTIME_SNAP="vim-runtime-20050601.tar.bz2"
VIM_NETRW_SNAP="vim-6.3.068-netrw.tar.bz2"
VIM_GENTOO_PATCHES="vim-${PV}-gentoo-patches.tar.bz2"
VIMRC_FILE_SUFFIX="-r1"

SRC_URI="${SRC_URI}
	ftp://ftp.vim.org/pub/vim/unix/vim-${VIM_VERSION}.tar.bz2
	nls? ( ftp://ftp.vim.org/pub/vim/extra/vim-${VIM_VERSION}-lang.tar.gz )
	mirror://gentoo/${VIM_GENTOO_PATCHES}
	mirror://gentoo/${VIM_RUNTIME_SNAP}
	mirror://gentoo/${VIM_NETRW_SNAP}
	mirror://gentoo/${VIM_ORG_PATCHES}"

S=${WORKDIR}/vim${VIM_VERSION/.}
DESCRIPTION="vim and gvim shared files"
KEYWORDS="alpha amd64 ~arm hppa ia64 mips ppc ppc64 ~s390 sparc x86"
IUSE="nls"
DEPEND="${DEPEND}"  # all the deps for vim-core are in vim.eclass
PDEPEND="!livecd? ( >=app-vim/gentoo-syntax-20050515 )"
