# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/gvim/gvim-6.3.086.ebuild,v 1.1 2005/09/22 19:52:44 ciaranm Exp $

inherit vim

VIM_VERSION="6.3"
VIM_GENTOO_PATCHES="vim-6.3.084-r1-gentoo-patches.tar.bz2"
VIM_ORG_PATCHES="vim-${PV}-patches.tar.bz2"
VIM_RUNTIME_SNAP="vim-runtime-20050809.tar.bz2"
GVIMRC_FILE_SUFFIX="-r1"

SRC_URI="${SRC_URI}
	ftp://ftp.vim.org/pub/vim/unix/vim-${VIM_VERSION}.tar.bz2
	nls? ( ftp://ftp.vim.org/pub/vim/extra/vim-${VIM_VERSION}-lang.tar.gz )
	mirror://gentoo/${VIM_GENTOO_PATCHES}
	mirror://gentoo/${VIM_ORG_PATCHES}
	mirror://gentoo/${VIM_RUNTIME_SNAP}"

S=${WORKDIR}/vim${VIM_VERSION/.}
DESCRIPTION="GUI version of the Vim text editor"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="gnome gtk motif nls"
PROVIDE="virtual/editor"
DEPEND="${DEPEND}
	~app-editors/vim-core-${PV}
	virtual/x11
	gtk? (
		>=x11-libs/gtk+-2.6
		virtual/xft
		gnome? ( >=gnome-base/libgnomeui-2.6 )
	)
	!gtk? ( motif? ( x11-libs/openmotif ) )"
