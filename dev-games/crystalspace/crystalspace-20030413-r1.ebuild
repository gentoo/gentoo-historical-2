# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/crystalspace/crystalspace-20030413-r1.ebuild,v 1.4 2003/07/18 23:17:43 vapier Exp $

DESCRIPTION="portable 3D Game Development Kit written in C++"
SRC_URI="mirror://gentoo/distfiles/${P}.tar.gz"
HOMEPAGE="http://crystal.sourceforge.net/"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="x86 ppc"
IUSE="oggvorbis mikmod openal truetype 3ds mng"

DEPEND=">=media-libs/libpng-1.2.1
	>=media-libs/jpeg-6b
	mng? ( media-libs/libmng )
	mikmod? ( media-libs/libmikmod )
	3ds? ( media-libs/lib3ds )
	truetype? ( >=media-libs/freetype-2.0 )
	openal? ( media-libs/openal )
	zlib? ( sys-libs/zlib )
	oggvorbis? ( >=media-libs/libogg-1.0
		>=media-libs/libvorbis-1.0 )
	x86? ( dev-lang/nasm )
	dev-libs/ode
	>=dev-lang/perl-5.6.1
	!dev-libs/crystalspace-cvs"

S=${WORKDIR}/CS

CRYSTAL_PREFIX=/opt/crystal

src_compile() {
	./configure --prefix=${CRYSTAL_PREFIX} || die
	make all || die
}

src_install() {
	dodir ${CRYSTAL_PREFIX}
	make INSTALL_DIR=${D}/${CRYSTAL_PREFIX} install || die
	dodir /usr/bin
	dosym ${CRYSTAL_PREFIX}/bin/cs-config /usr/bin/cs-config
}
