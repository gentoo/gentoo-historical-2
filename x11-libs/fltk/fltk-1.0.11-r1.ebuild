# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Tod Neidt <tneidt@fidnet.com>
# $Header: /var/cvsroot/gentoo-x86/x11-libs/fltk/fltk-1.0.11-r1.ebuild,v 1.2 2002/04/27 23:34:20 bangert Exp $

S=${WORKDIR}/${P}

DESCRIPTION="C++ user interface toolkit for X and OpenGL."

SRC_URI="ftp://ftp.fltk.org/pub/fltk/${MYVER}/${P}-source.tar.bz2"

HOMEPAGE="http://www.fltk.org"

DEPEND="virtual/glibc 
	virtual/x11 
	opengl? ( virtual/opengl )"


src_compile() {

	local myconf
	#shared libraries diabled by default
	myconf="--enable-shared"

	use opengl || myconf="$myconf --disable-gl" #default enabled
	
#Learned '${prefix}' trick from studying python ebuild
#There are no info files 
    ./configure \
		--prefix=/usr \
		--mandir='${prefix}'/share/man \
		--host=${CHOST} || die "Configuration Failed"
		
    emake || die "Parallel Make Failed"

}

src_install () {

    make prefix=${D}/usr/ \
		install || die "Installation Failed"
		
    dodoc CHANGES COPYING README
	
	dodir /usr/share/doc/${PF}/html
    mv ${D}/usr/share/doc/fltk/* ${D}/usr/share/doc/${PF}/html
	rmdir ${D}/usr/share/doc/fltk

}

