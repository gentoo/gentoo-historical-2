# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/cream/cream-0.28.ebuild,v 1.4 2004/06/24 23:00:58 agriffis Exp $

inherit vim-plugin

DESCRIPTION="Cream is an easy-to-use configuration of the GVim text editor"
HOMEPAGE="http://cream.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 sparc ~mips ~ppc"
IUSE=""
DEPEND=""
RDEPEND=">=app-editors/gvim-6.2"
S=${WORKDIR}/${P}

src_install() {
	newbin ${FILESDIR}/cream.sh cream
	insinto /usr/share/vim/cream
	doins *.vim .vimrc .gvimrc
	local dir
	for dir in addons bitmaps spelldicts views ; do
		cp -R ${dir} ${D}/usr/share/vim/cream
	done
	dodir /usr/share/vim/vimfiles
	cp -R help ${D}/usr/share/vim/vimfiles/doc
	dodoc docs/*
	dohtml docs-html/*
}
