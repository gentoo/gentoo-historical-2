# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/gvim/gvim-6.3_beta2.ebuild,v 1.2 2004/05/25 22:34:18 lu_zero Exp $

inherit vim

VIM_VERSION="6.3b"
VIM_GENTOO_PATCHES="vim-6.2.070-gentoo-patches.tar.bz2"
VIM_ORG_PATCHES="vim-6.3b.002-patches.tar.bz2"

SRC_URI="${SRC_URI}
	ftp://ftp.vim.org/pub/vim/unstable/unix/vim-${VIM_VERSION}.tar.bz2
	nls? ( ftp://ftp.vim.org/pub/vim/unstable/extra/vim-${VIM_VERSION}-lang.tar.gz )
	mirror://gentoo/${VIM_GENTOO_PATCHES}
	mirror://gentoo/${VIM_ORG_PATCHES}"

S=${WORKDIR}/vim${VIM_VERSION/.}
DESCRIPTION="Graphical Vim"
KEYWORDS="~sparc ~mips ~ppc"
PROVIDE="virtual/editor"
DEPEND="${DEPEND}
	~app-editors/vim-core-${PV}
	virtual/x11
	gtk? (
		gtk2? ( >=x11-libs/gtk+-2.1 virtual/xft )
		!gtk2? (
			gnome? ( gnome-base/gnome-libs )
			!gnome? ( =x11-libs/gtk+-1.2* )
		)
	)
	!gtk? ( motif? ( x11-libs/openmotif ) )"
