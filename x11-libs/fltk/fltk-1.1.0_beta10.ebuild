# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Tod Neidt <tneidt@fidnet.com>
# $Header: /var/cvsroot/gentoo-x86/x11-libs/fltk/fltk-1.1.0_beta10.ebuild,v 1.3 2002/07/09 10:53:20 aliz Exp $

MYVER=${PV/_beta/b}
S=${WORKDIR}/${PN}-${MYVER}

DESCRIPTION="C++ user interface toolkit for X and OpenGL."
LICENSE="FLTK | GPL-2"
SLOT="0"
KEYWORDS="x86"

SRC_URI="ftp://ftp.easysw.com/pub/fltk/${MYVER}/${PN}-${MYVER}-source.tar.bz2"

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

