# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/sam2p/sam2p-0.45-r1.ebuild,v 1.8 2008/08/29 21:52:14 aballier Exp $

inherit toolchain-funcs eutils autotools

DESCRIPTION="Utility to convert raster images to EPS, PDF and many others"
HOMEPAGE="http://www.inf.bme.hu/~pts/sam2p/"
# The author refuses to distribute
SRC_URI="mirror://gentoo/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="examples gif"
DEPEND="dev-lang/perl"
RDEPEND="virtual/libc"

RESTRICT="test"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-fbsd.patch"
	epatch "${FILESDIR}/${P}-nostrip.patch"
	epatch "${FILESDIR}/${P}-cflags.patch"
	epatch "${FILESDIR}/${P}-parallelmake.patch"
	eautoreconf
}

src_compile() {
	tc-export CXX
	# Makedep fails with distcc
	PATH=${PATH#/usr/lib/distcc/bin:}
	econf --enable-lzw $(use_enable gif) || die "econf failed"
	emake || die "make failed"
}

src_install() {
	dobin sam2p || die "Failed to install sam2p"
	dodoc README
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*
	fi
}
