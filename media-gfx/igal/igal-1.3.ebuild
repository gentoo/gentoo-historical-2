# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/igal/igal-1.3.ebuild,v 1.5 2003/03/11 21:11:46 seemant Exp $

S="${WORKDIR}/${P}"
DESCRIPTION="Static HTML image gallery generator"
HOMEPAGE="http://www.stanford.edu/~epop/igal/"
SRC_URI="http://www.stanford.edu/~epop/igal/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc ~sparc ~alpha"

RDEPEND="dev-lang/perl
		media-gfx/imagemagick"

src_unpack(){
	unpack ${P}.tar.gz
	patch -p0 < ${FILESDIR}/${P}-gentoo.diff
}

src_compile(){
	make || die
}

src_install(){
	dodir /usr/share/igal/lib
	insinto /usr/share/igal/lib
	doins indextemplate.html
	doins slidetemplate.html
	doins tile.gif
	into /usr
	dobin igal
	doman igal.1
	dodoc ChangeLog COPYING README
}

