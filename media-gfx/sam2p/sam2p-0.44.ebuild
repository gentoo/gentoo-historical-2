# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/sam2p/sam2p-0.44.ebuild,v 1.7 2005/07/14 13:09:57 swegener Exp $

inherit toolchain-funcs

DESCRIPTION="A utility to convert raster images to PDF and others"
HOMEPAGE="http://www.inf.bme.hu/~pts/sam2p/"
# The author refuses to distribute 
SRC_URI="mirror://gentoo/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc x86"
IUSE="gif"
DEPEND="dev-lang/perl
	sys-devel/gcc-config"

S=${WORKDIR}

src_compile() {
	local myconf="--enable-lzw `use_enable gif`"
	# Makedep borks if distcc is used, so disable it for econf by
	# overriding the path to g++
	CXX="$(tc-getCXX)" econf ${myconf} || die
	make || die
}

src_install() {
	einstall
	dodoc README
}
