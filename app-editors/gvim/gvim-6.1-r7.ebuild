# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/gvim/gvim-6.1-r7.ebuild,v 1.9 2003/09/05 23:05:05 msterret Exp $

inherit vim eutils

VIM_VERSION="6.1"
VIM_GENTOO_PATCHES="vim-6.1-gentoo-patches.tar.bz2"
VIM_ORG_PATCHES="vim-6.1-patches-001-390.tar.bz2"

S=${WORKDIR}/vim${VIM_VERSION/.}
SRC_URI="${SRC_URI}
	ftp://ftp.vim.org/pub/vim/unix/vim-6.1.tar.bz2
	nls? ( ftp://ftp.vim.org/pub/vim/extra/vim-6.1-lang.tar.gz )
	mirror://gentoo/${VIM_GENTOO_PATCHES}
	mirror://gentoo/${VIM_ORG_PATCHES}"

DESCRIPTION="Graphical Vim"
KEYWORDS="~alpha ~ppc ~sparc x86"
PROVIDE="virtual/editor"
DEPEND="${DEPEND}
	~app-editors/vim-core-6.1
	x11-base/xfree
	gtk2? ( >=x11-libs/gtk+-2.1 virtual/xft ) :
		( gnome? ( gnome-base/gnome-libs ) :
			( gtk? ( =x11-libs/gtk+-1.2* ) ) )"

src_unpack() {
	vim_src_unpack

	use gtk2 \
		&& EPATCH_SUFFIX="gz" EPATCH_FORCE="yes" \
			epatch ${WORKDIR}/gentoo/patches-gvim/*
}
