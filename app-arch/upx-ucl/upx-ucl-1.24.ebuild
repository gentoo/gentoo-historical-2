# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/upx-ucl/upx-ucl-1.24.ebuild,v 1.5 2004/06/24 21:39:07 agriffis Exp $

MY_P=${P/-ucl/}
S=${WORKDIR}/${MY_P}
DESCRIPTION="upx is the Ultimate Packer for eXecutables."
HOMEPAGE="http://upx.sourceforge.net"
SRC_URI="mirror://sourceforge/upx/${MY_P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc"

IUSE=""

DEPEND="dev-libs/ucl
	dev-lang/perl
	!app-arch/upx"

src_compile() {

	sed -ie "s:CXX =:CXX =g++:" src/Makefile

	make -C src UCLDIR=/usr CFLAGS_O="${CFLAGS}" || die "Failed compiling"
	make -C doc || "Failed making documentation"
}

src_install() {

	dobin src/upx

	dodoc BUGS LICENSE LOADER.TXT NEWS PROJECTS README README.SRC THANKS doc/upx.doc
	dohtml doc/upx.html
	doman doc/upx.1
}
