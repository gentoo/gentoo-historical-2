# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/pngcrush/pngcrush-1.5.10.ebuild,v 1.5 2002/10/18 20:59:13 vapier Exp $

S=${WORKDIR}/${P}

DESCRIPTION="PNG optimizing tool"
SRC_URI="mirror://sourceforge/pmt/${P}.tar.gz"
HOMEPAGE="http://pmt.sourceforge.net/pngcrush/"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ppc"

DEPEND="virtual/glibc"
RDEPEND="${DEPEND}"

src_compile() {
	cp Makefile.gcc Makefile
	emake CFLAGS="-I. ${CFLAGS}" || die
}

src_install() {
	dobin pngcrush
}
