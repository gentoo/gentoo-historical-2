# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/gvim/gvim-7.0_beta.ebuild,v 1.3 2006/03/29 19:50:19 corsair Exp $

inherit vim

VIM_VERSION="7.0b"
VIM_SNAPSHOT="vim-${PV}.tar.bz2"
VIM_GENTOO_PATCHES="vim-7.0_alpha20051207-gentoo-patches.tar.bz2"
GVIMRC_FILE_SUFFIX="-r1"

SRC_URI="${SRC_URI}
	mirror://gentoo/${VIM_SNAPSHOT}
	mirror://gentoo/${VIM_GENTOO_PATCHES}"

S=${WORKDIR}/vim${VIM_VERSION/.*}
DESCRIPTION="GUI version of the Vim text editor"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~x86"
IUSE="aqua gnome gtk motif nextaw"
PROVIDE="virtual/editor"
DEPEND="${DEPEND}
	~app-editors/vim-core-${PV}
	|| ( x11-libs/libXext virtual/x11 )
	!aqua? (
		gtk? (
			>=x11-libs/gtk+-2.6
			virtual/xft
			gnome? ( >=gnome-base/libgnomeui-2.6 )
		)
		!gtk? (
			motif? (
				x11-libs/openmotif
			)
			!motif? (
				nextaw? (
					x11-libs/neXtaw
				)
				!nextaw? (
					|| ( x11-libs/libXaw virtual/x11 )
				)
			)
		)
	)"
