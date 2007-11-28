# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/realpath/realpath-1.9.16.ebuild,v 1.10 2007/11/28 15:33:38 grobian Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Return the canonicalized absolute pathname"
HOMEPAGE="http://packages.debian.org/unstable/utils/realpath.html"
SRC_URI="mirror://debian/pool/main/d/dwww/dwww_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc mips amd64 ppc64 ~hppa"
IUSE=""

S=${WORKDIR}/dwww-${PV}

src_unpack() {
	unpack ${A}

	cd "${S}"
	epatch "${FILESDIR}"/${P}-Makefile.patch

	sed -i -e "s:gcc:$(tc-getCC):" Makefile || die "sed failed."
}

src_compile() {
	make LIBS='' VERSION=$PV realpath || die
}

src_install() {
	dobin realpath || die
	doman man/realpath.1
	dodoc README TODO BUGS
}
