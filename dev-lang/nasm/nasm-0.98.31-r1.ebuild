# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>
# /space/gentoo/cvsroot/gentoo-x86/dev-lang/nasm/nasm-0.98.30.ebuild,v 1.1 2002/05/06 08:20:25 kain Exp

S=${WORKDIR}/${P}
DESCRIPTION="groovy little assembler"
SRC_URI="http://unc.dl.sourceforge.net/sourceforge/nasm/${P}.tar.bz2
http://telia.dl.sourceforge.net/sourceforge/nasm/${P}.tar.bz2
http://belnet.dl.sourceforge.net/sourceforge/nasm/${P}.tar.bz2"
HOMEPAGE="http://nasm.2y.net/"

DEPEND="virtual/glibc build? ( sys-devel/perl )
	doc? ( app-text/ghostscript sys-apps/texinfo )
	sys-devel/gcc"
RDEPEND="virtual/glibc"

src_unpack() {

    cd ${WORKDIR}
    unpack ${A}

    if [ -z "`use doc`" ]; then
        cd ${S}
	patch -p0 < ${FILESDIR}/${P}-remove-doc-target.diff
    fi

}

src_compile() {                           

    ./configure --prefix=/usr || die

    if [ "`use build`" ]; then
	make nasm 
    else
	make everything || die
    fi
    
}

src_install() {

    if [ "`use build`" ]; then
	dobin nasm
    else
	dobin nasm ndisasm rdoff/{ldrdf,rdf2bin,rdf2ihx,rdfdump,rdflib,rdx}
	dosym /usr/bin/rdf2bin /usr/bin/rdf2com
	doman nasm.1 ndisasm.1
	dodoc AUTHORS CHANGES COPYING ChangeLog INSTALL README TODO
	if [ -n "`use doc`" ]; then
	    doinfo doc/info/*
	    dohtml doc/html/*
	    dodoc doc/nasmdoc.*
	fi
    fi
    
}
