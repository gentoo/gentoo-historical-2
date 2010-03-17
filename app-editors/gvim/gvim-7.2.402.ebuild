# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/gvim/gvim-7.2.402.ebuild,v 1.1 2010/03/17 22:01:00 lack Exp $

EAPI=2
inherit vim

VIM_VERSION="7.2"
VIM_ORG_PATCHES="vim-patches-${PV}.tar.gz"
GVIMRC_FILE_SUFFIX="-r1"
GVIM_DESKTOP_SUFFIX="-r2"

SRC_URI="ftp://ftp.vim.org/pub/vim/unstable/unix/vim-${VIM_VERSION}.tar.bz2
	ftp://ftp.vim.org/pub/vim/extra/vim-${VIM_VERSION}-lang.tar.gz
	ftp://ftp.vim.org/pub/vim/extra/vim-${VIM_VERSION}-extra.tar.gz
	mirror://gentoo/${VIM_ORG_PATCHES}"

S="${WORKDIR}/vim${VIM_VERSION/.}"
DESCRIPTION="GUI version of the Vim text editor"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""
