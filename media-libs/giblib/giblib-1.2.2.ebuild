# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/giblib/giblib-1.2.2.ebuild,v 1.4 2002/10/06 23:18:34 owen Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Giblib, graphics library"
HOMEPAGE="http://www.libuxbrit.co.uk/"
SRC_URI="http://www.linuxbrit.co.uk/downloads/${P}.tar.gz"

SLOT="0"
LICENSE="as-is|BSD"
KEYWORDS="x86 ppc sparc sparc64"

DEPEND=">=media-libs/imlib2-1.0.3
	>=media-libs/freetype-2.0"
RDEPEND="$DEPEND"

src_compile() {
	econf || die
	emake || die
}

src_install () {	
	make prefix=${D}/usr install || die
	rm -rf ${D}/usr/doc
	dodoc TODO README AUTHORS ChangeLog
}
