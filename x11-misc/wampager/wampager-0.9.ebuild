# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/x11-misc/wampager/wampager-0.9.ebuild,v 1.3 2002/07/11 06:30:57 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Pager for Waimea."
SRC_URI="http://download.sourceforge.net/waimea/${P}.tar.gz"
HOMEPAGE="http://waimea.sf.net"
LICENSE="GPL-2"

DEPEND="virtual/x11 x11-wm/waimea"
         
RDEPEND="${DEPEND}"
PROVIDE="virtual/blackbox"
SLOT="0"
KEYWORDS="x86"

src_unpack() {
	unpack ${A}
	cd ${S}
	patch -p0 < ${FILESDIR}/${P}-gentoo.patch
	# now sed in a proper build image dir removing sandbox violates.
	mv Makefile Makefile.pre
	cat Makefile.pre | sed -e "s#@@@IMAGE_PRE@@@#${BUILDDIR}/image#" > Makefile
}
src_compile() {
	emake || die
}
src_install () {
	make install || die
}
																	 
