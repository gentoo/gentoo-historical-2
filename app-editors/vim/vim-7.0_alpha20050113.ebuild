# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/vim/vim-7.0_alpha20050113.ebuild,v 1.1 2005/01/13 22:18:05 ciaranm Exp $

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
DESCRIPTION="Vim, an improved vi-style text editor"
KEYWORDS="~x86 ~sparc ~mips ~ppc ~amd64 ~ppc64 ~alpha"
IUSE="${IUSE}"
PROVIDE="virtual/editor"
DEPEND="${DEPEND}
	~app-editors/vim-core-${PV}"
