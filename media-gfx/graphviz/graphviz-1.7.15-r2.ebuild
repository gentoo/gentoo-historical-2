# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/graphviz/graphviz-1.7.15-r2.ebuild,v 1.11 2003/02/13 12:34:38 vapier Exp $

IUSE="tcltk"

S=${WORKDIR}/${P}
DESCRIPTION="open source graph drawing software"
SRC_URI="http://www.research.att.com/sw/tools/graphviz/dist/$P.tgz"
HOMEPAGE="http://www.research.att.com/sw/tools/graphviz/"

SLOT="0"
LICENSE="as-is | ATT"
KEYWORDS="x86 ppc"

#Can use freetype-1.3 or 2.0, but not both
#Has some problems with gcc-3.x
DEPEND=">=sys-libs/zlib-1.1.3
	=sys-devel/gcc-2.95*
	media-libs/libpng
	>=media-libs/jpeg-6b
	media-libs/freetype
	tcltk? ( =dev-lang/tk-8.3* )"

src_compile() {
	local myconf
	#if no tcltk, this will generate configure warnings, but will
	#compile without tcltk support
	use tcltk || myconf="${myconf} --without-tcl --without-tk"

	#They seem to have forgot configure when packaging 1.7.15
	./autogen.sh --infodir=/usr/share/info \
		--mandir=/usr/share/man \
		--prefix=/usr \
		--host=${CHOST} \
		${myconf} || die

	make || die
}

src_install() {
	make DESTDIR=${D} install || die

	dodoc AUTHORS ChangeLog FAQ.txt INSTALL  MINTERMS.txt \
		NEWS README 
	
	dohtml -r .
	dodoc doc/*.pdf
}
