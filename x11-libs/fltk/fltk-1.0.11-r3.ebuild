# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/fltk/fltk-1.0.11-r3.ebuild,v 1.6 2002/10/05 05:39:27 drobbins Exp $

IUSE="opengl"

S=${WORKDIR}/${P}
DESCRIPTION="C++ user interface toolkit for X and OpenGL."
SRC_URI="ftp://ftp.fltk.org/pub/fltk/${PV}/${P}-source.tar.bz2"
HOMEPAGE="http://www.fltk.org"

SLOT="1.0"
LICENSE="FLTK | GPL-2"
KEYWORDS="x86 sparc sparc64"

DEPEND="virtual/x11 
	opengl? ( virtual/opengl )"


src_compile() {

	local myconf
	myconf="--enable-shared"

	use opengl || myconf="${myconf} --disable-gl" #default enabled
	
	econf \
		--includedir=/usr/include/fltk-1.0 \
		--libdir=/usr/lib/fltk-1.0 \
		--program-suffix=-old \
		${myconf} || die "Configuration Failed"

	emake CXX="g++" || die "Parallel Make Failed"

}

src_install () {

	einstall \
		includedir=${D}/usr/include/fltk-1.0 \
		libdir=${D}/usr/lib/fltk-1.0 || die "Installation Failed"
		
    dodoc CHANGES COPYING README
	
	dodir /usr/share/doc/${PF}/html
	mv ${D}/usr/share/doc/fltk/* ${D}/usr/share/doc/${PF}/html
	rmdir ${D}/usr/share/doc/fltk

	echo "LDPATH=/usr/lib/fltk-1.0" > 99fltk1.0
	insinto /etc/env.d
	doins 99fltk1.0
}
