# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/uudeview/uudeview-0.5.13.ebuild,v 1.7 2002/10/20 18:40:56 vapier Exp $

IUSE="tcltk"


S="${WORKDIR}/${P}"
DESCRIPTION="uu, xx, base64, binhex decoder"
SRC_URI="http://ibiblio.org/pub/Linux/utils/text/${P}.tar.gz"
HOMEPAGE="http://www.fpx.de/fp/Software/UUDeview/"
KEYWORDS="x86 sparc sparc64"
SLOT="0"
LICENSE="GPL-2"
DEPEND="tcltk?  ( dev-lang/tcl dev-lang/tk )"

src_compile() {
	local myconf
	use tcltk || myconf="--disable-tcl --disable-tk"
	
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		${myconf} \
		--mandir=${D}/usr/share/man || die "./configure failed"
	emake || die
}

src_install () {
	make \
		prefix=${D}/usr \
		infodir=${D}/usr/share/info \
		install || die

	# Install documentation.
	dodoc COPYING INSTALL README
}
