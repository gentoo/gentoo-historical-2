# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/crystalspace-cvs/crystalspace-cvs-0.97.ebuild,v 1.2 2003/07/15 23:59:39 vapier Exp $

inherit cvs
ECVS_SERVER="cvs.sourceforge.net:/cvsroot/crystal"
ECVS_MODULE="CS"
ECVS_TOP_DIR="${DISTDIR}/cvs-src/${PN}"
S=${WORKDIR}/${ECVS_MODULE}

DESCRIPTION="portable 3D Game Development Kit written in C++"
SRC_URI=""
HOMEPAGE="http://crystal.sourceforge.net/"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="~x86 ~ppc"

DEPEND=">=media-libs/libpng-1.2.1
	>=media-libs/jpeg-6b
	mng? ( media-libs/libmng )
	mikmod? ( media-libs/libmikmod )
	3ds? ( media-libs/lib3ds )
	freetype? ( >=media-libs/freetype-2.0 )
	openal? ( media-libs/openal )
	zlib? ( sys-libs/zlib )
	oggvorbis? ( >=media-libs/libogg-1.0
		>=media-libs/libvorbis-1.0 )
	x86? ( dev-lang/nasm )
	dev-libs/ode
	>=dev-lang/perl-5.6.1
	!dev-libs/crystalspace"

CRYSTAL_PREFIX=/opt/crystal

src_compile() {
	./configure --prefix=${CRYSTAL_PREFIX} || die
	emake all || die
}

src_install() {
	dodir ${CRYSTAL_PREFIX}
	make INSTALL_DIR=${D}/${CRYSTAL_PREFIX} install || die
	dodir /usr/bin
	dosym ${CRYSTAL_PREFIX}/bin/cs-config /usr/bin/cs-config
}
