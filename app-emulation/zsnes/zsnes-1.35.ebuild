# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/zsnes/zsnes-1.35.ebuild,v 1.9 2003/02/28 23:33:34 vapier Exp $

DESCRIPTION="excellent snes (super nintendo) emulator"
SRC_URI="mirror://sourceforge/zsnes/zsnes${PV//./}src.tar.gz"
HOMEPAGE="http://www.zsnes.com/"

LICENSE="GPL-2"
KEYWORDS="x86 -ppc -sparc"
SLOT="0"
IUSE="opengl"

RDEPEND="opengl? ( virtual/opengl )
	virtual/x11
	>=media-libs/libsdl-1.2.0
	sys-libs/zlib
	media-libs/libpng"
DEPEND="${RDEPEND}
	>=dev-lang/nasm-0.98"

src_compile() {
	# Don't attempt to introduce $CFLAGS usage, docs say result will be slower.
	patch -p1 < ${FILESDIR}/${P}-gentoo.patch
	cd ${S}/src
	use opengl || myconf="--without-opengl"
	./configure --prefix=/usr --host=${CHOST} $myconf || die
	make || die
}

src_install() {
	cd ${S}/src
	into /usr
	dobin zsnes
	doman linux/zsnes.man
	cd ${S}
	dodoc *.txt linux/*
}
