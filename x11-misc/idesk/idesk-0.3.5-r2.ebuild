# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2              
# $Header: /var/cvsroot/gentoo-x86/x11-misc/idesk/idesk-0.3.5-r2.ebuild,v 1.3 2003/07/18 08:12:05 pvdabeel Exp $                                                                    
DESCRIPTION="Utility to place icons on the root window"                         
                                                                                
HOMEPAGE="http://cvs.gentoo.org/~absinthe/idesk/index.html"
SRC_URI="http://cvs.gentoo.org/~absinthe/idesk/${P}.tar.gz"                  
LICENSE="BSD"                                                                   
SLOT="0"                                                                        
KEYWORDS="x86 ppc"
                                                                                
DEPEND=">media-libs/imlib-1.9.14
	virtual/x11
	media-libs/freetype"

S="${WORKDIR}/${P}"                                                            

src_unpack() {
	unpack ${A}
	cd ${S}

	# fix for xft2 the ugly way	
	CXXFLAGS="${CXXFLAGS} -I/usr/include/freetype2 -U__linux__"
	#Allow for more robust CXXFLAGS
	mv Makefile Makefile.orig
	sed -e "s:-g -O2:${CXXFLAGS}:" Makefile.orig > Makefile
}

src_compile() {
	epatch ${FILESDIR}/${P}-clickbox-and-singleclick.patch
	emake || die
}	

src_install() {                                                                
	exeinto /usr/bin
	doexe idesk	                                  
	dodoc README
	doman ${FILESDIR}/idesk.1 ${FILESDIR}/ideskrc.5
}                                                                               

pkg_postinst() {
	einfo
	einfo "NOTE: Please refer to ${HOMEPAGE}"
	einfo "NOTE: For info on configuring ${PN}"
	einfo
}	
