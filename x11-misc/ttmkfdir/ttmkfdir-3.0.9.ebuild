# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/ttmkfdir/ttmkfdir-3.0.9.ebuild,v 1.16 2005/02/08 02:46:34 spyderous Exp $

IUSE=""

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="A utility to create a fonts.scale file from a set of TrueType fonts"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
HOMEPAGE="http://www.joerg-pommnitz.de/TrueType/xfsft.html"

LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 sparc ppc alpha hppa ia64 mips"

DEPEND=">=media-libs/freetype-2.0.8
	>=sys-devel/flex-2.5.4a-r5
	sys-devel/libtool"

src_unpack() {
	unpack ${A}

	cd ${S}; epatch ${FILESDIR}/${P}-gcc33.patch
}

src_compile() {
	filter-flags "-O -O1 -O2 -O3"
	make CXX="$(tc-getCXX)" \
		OPTFLAGS="${CFLAGS}" DEBUG="" || die
}

src_install() {
	exeinto /usr/X11R6/bin
	doexe ${S}/ttmkfdir

	dodoc ${S}/README
}
