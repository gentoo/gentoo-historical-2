# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/media-gfx/graphviz/graphviz-1.7.15-r1.ebuild,v 1.3 2002/07/11 06:30:27 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="open source graph drawing software"
SRC_URI="http://www.research.att.com/sw/tools/graphviz/dist/$P.tgz"
HOMEPAGE="http://www.research.att.com/sw/tools/graphviz/"

#Can use freetype-1.3 or 2.0, but not both
DEPEND=">=sys-libs/zlib-1.1.3
	>=media-libs/libpng-1.0.6
	>=media-libs/jpeg-6b
	media-libs/freetype
	tcltk? ( =dev-lang/tk-8.3* )"

src_compile() {

	local myconf
	#if no tcltk, this will generate configure warnings, but will
	#compile without tcltk support
	use tcltk || myconf="$myconf --without-tcl --without-tk"

	#They seem to have forgot configure when packaging 1.7.15
	./autogen.sh --infodir=/usr/share/info \
		--mandir=/usr/share/man \
		--prefix=/usr \
		--host=${CHOST} \
		${myconf} || die

    make || die
	
}

src_install () {
   
   make DESTDIR=${D} install || die

	dodoc AUTHORS ChangeLog FAQ.txt INSTALL  MINTERMS.txt \
		NEWS README 
	
	insinto /usr/share/doc/${P}/html
	doins LICENSE.html doc/*.html 
	
	
	insinto /usr/share/doc/${P}/pdf
	doins doc/*.pdf
		
}
