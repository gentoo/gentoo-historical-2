# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/zsnes/zsnes-1.35-r1.ebuild,v 1.8 2002/12/09 04:17:42 manson Exp $

# Don't attempt to introduce $CFLAGS usage, docs say result will be slower.

IUSE="opengl"

S=${WORKDIR}/${P}
DESCRIPTION="ZSNES is a SNES (Super Nintendo) emulator that uses x86 assembly."
SRC_URI="mirror://sourceforge/zsnes/zsnes135src.tar.gz"
HOMEPAGE="http://www.zsnes.com/"
LICENSE="GPL-2"
KEYWORDS="x86 -sparc  -ppc"
SLOT="0"

RDEPEND="opengl? ( virtual/opengl )
	virtual/x11
	>=media-libs/libsdl-1.2.0
	sys-libs/zlib
	media-libs/libpng"

DEPEND="${RDEPEND}
	>=dev-lang/nasm-0.98"


src_compile() {
	patch -p1 < ${FILESDIR}/${P}-cvs.patch || die "CVS patch failed"
	cd ${S}/src
	use opengl || myconf="--without-opengl"
	./configure --prefix=/usr --host=${CHOST} $myconf || die
	make || die
}
src_install () {
	cd ${S}/src
	into /usr
	dobin zsnes
	doman linux/zsnes.1
	cd ${S}
	dodoc *.txt linux/*
}
