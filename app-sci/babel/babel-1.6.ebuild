# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/babel/babel-1.6.ebuild,v 1.6 2002/10/17 14:26:47 vapier Exp $

S=${WORKDIR}/${P}

DESCRIPTION="Babel is a program to interconvert file formats used in molecular modeling."

SRC_URI="http://smog.com/chem/babel/files/${P}.tar.Z"

HOMEPAGE="http://smog.com/chem/babel/"
KEYWORDS="x86"
SLOT="0"
LICENSE="as-is"

#Doesn't really seem to depend on anything (?)
DEPEND="virtual/glibc"
RDEPEND=$DEPEND

PROVIDE="app-misc/babel"

src_unpack() {

	unpack ${P}.tar.Z
	cd ${S}
#Patch the Makefile for gentoo-isms 
	patch -p0 < ${FILESDIR}/${P}-gentoo.diff || die
	patch -p0 < ${FILESDIR}/${P}-gcc32.diff || die

}

src_compile() {
	
	emake || die

}

src_install () {

	make DESTDIR=${D}/usr/bin install || die

	insinto /usr/share/${PN}
	doins ${S}/*.lis
	
	insinto /etc/env.d
	doins ${FILESDIR}/10babel

	dodoc README.1ST
	
}

