# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/blt/blt-2.4z.ebuild,v 1.2 2003/07/09 19:25:47 cretin Exp $


S="${WORKDIR}/${PN}${PV}"
SRC_URI="mirror://sourceforge/blt/BLT2.4z.tar.gz"
HOMEPAGE="http://www.sourceforge.net/blt/"
DESCRIPTION="an extension to the Tk toolkit"

DEPEND=">=dev-lang/tk-8.0"

SLOT="0"
LICENSE="BSD"
KEYWORDS="x86"

# hyper-optimizations untested...
#

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/blt2.4z-install.diff
}

src_compile() {

	cd ${S}
	./configure --host=${CHOST} \
				--prefix=/usr \
				--mandir=/usr/share/man \
				--infodir=/usr/share/info \
				--with-x \
				--with-tcl=/usr/lib || die "./configure failed"
					
	emake CFLAGS="${CFLAGS}" || die
	
}

src_install() {
	
	dodir /usr/bin
	dodir /usr/lib/blt2.4/demos/bitmaps
	dodir /usr/share/man/mann
	dodir /usr/include
	emake \
			INSTALL_ROOT=${D} \
			install || die	
	
	dodoc NEWS PROBLEMS README
}
