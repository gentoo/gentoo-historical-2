# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/ttmkfdir/ttmkfdir-3.0.9-r1.ebuild,v 1.13 2004/06/12 17:27:49 kloeri Exp $

inherit eutils flag-o-matic gcc

DESCRIPTION="A utility to create a fonts.scale file from a set of TrueType fonts"
HOMEPAGE="http://www.joerg-pommnitz.de/TrueType/xfsft.html"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 ppc sparc ~mips alpha arm hppa amd64 ia64"
IUSE=""

RDEPEND="virtual/glibc
	sys-libs/zlib
	>=media-libs/freetype-2.0.8"
DEPEND="${RDEPEND}
	>=sys-devel/flex-2.5.4a-r5
	sys-devel/libtool"

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${P}-cpp.patch
	epatch ${FILESDIR}/${P}-zlib.patch
	epatch ${FILESDIR}/${P}-gcc34.patch
}

src_compile() {
	filter-flags -O -O1 -O2 -O3
	emake \
		CXX="$(gcc-getCXX)" \
		OPTFLAGS="${CFLAGS}" \
		DEBUG="" \
		|| die "emake failed"
}

src_install() {
	exeinto /usr/X11R6/bin
	doexe ttmkfdir || die "doexe failed"
	dodoc README
}
