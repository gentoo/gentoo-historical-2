# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/vim-core/vim-core-7.0_alpha20050113.ebuild,v 1.1 2005/01/13 22:17:07 ciaranm Exp $

inherit vim

VIM_DATESTAMP="${PV##*alpha}"
VIM_PATCHES_DATESTAMP="20050113"

VIM_VERSION="7.0aa"
VIM_SNAPSHOT="vim-${VIM_VERSION}-${VIM_DATESTAMP}.tar.bz2"
VIM_GENTOO_PATCHES="vim-${VIM_VERSION}-${VIM_PATCHES_DATESTAMP:-${VIM_DATESTAMP}}-gentoo-patches.tar.bz2"

SRC_URI="${SRC_URI}
	mirror://gentoo/${VIM_SNAPSHOT}
	mirror://gentoo/${VIM_GENTOO_PATCHES}"

S=${WORKDIR}/vim${VIM_VERSION/.*}
DESCRIPTION="vim, gvim and kvim shared files"
KEYWORDS="~x86 ~sparc ~mips ~ppc ~amd64 ~ppc64 ~alpha"
IUSE="${IUSE} livecd"
DEPEND="${DEPEND}" # done via the eclass
PDEPEND="!livecd? ( app-vim/gentoo-syntax )"
