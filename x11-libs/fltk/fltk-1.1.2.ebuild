# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/fltk/fltk-1.1.2.ebuild,v 1.1 2002/12/09 03:40:28 raker Exp $

IUSE="opengl"

S=${WORKDIR}/${P}

DESCRIPTION="C++ user interface toolkit for X and OpenGL."
HOMEPAGE="http://www.fltk.org"
SRC_URI="ftp://ftp.easysw.com/pub/fltk/${PV}/${P}-source.tar.bz2"

SLOT="1.1"
KEYWORDS="~x86 ~ppc ~sparc ~sparc64"
LICENSE="FLTK | GPL-2"

DEPEND="media-libs/libpng
	media-libs/jpeg
	opengl? ( virtual/opengl )
	virtual/x11"

src_unpack() {

	unpack ${A}
	cd ${S}
	patch -p1 < ${FILESDIR}/libs.diff || die "patch failed"

}

src_compile() {

	local myconf
	myconf="--enable-shared --enable-static --enable-threads \
		--enable-xft --enable-xdbe"

	use opengl || myconf="${myconf} --disable-gl"

	export CXX="g++"

	econf \
		--includedir=/usr/include/fltk-1.1 \
		--libdir=/usr/lib/fltk-1.1 \
		${myconf} || die "Configuration Failed"

	emake || die "Parallel Make Failed"

}

src_install () {

	einstall \
		includedir=${D}/usr/include/fltk-1.1 \
		libdir=${D}/usr/lib/fltk-1.1 || die "Installation
Failed"
		
	ranlib ${D}/usr/lib/fltk-1.1/*.a

	dodoc CHANGES COPYING README
	
	echo "LDPATH=/usr/lib/fltk-1.1" > 99fltk-1.1

	insinto /etc/env.d
	doins 99fltk-1.1
}
