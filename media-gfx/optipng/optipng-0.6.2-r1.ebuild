# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/optipng/optipng-0.6.2-r1.ebuild,v 1.2 2009/02/25 20:10:47 maekke Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Compress PNG files without affecting image quality"
HOMEPAGE="http://optipng.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	mirror://sourceforge/${PN}/${P}.1.diff"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc x86"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${DISTDIR}"/${P}.1.diff
	sed -i \
		-e '/^C/s: -O2.*: $(GENTOO_CFLAGS) -Wall:' \
		-e '/^LD/s: -s$: $(GENTOO_LDFLAGS):' \
		src/scripts/gcc.mak \
		lib/libpng/scripts/makefile.gcc \
		lib/pngxtern/scripts/gcc.mak \
		|| die "sed failed"
}

src_compile() {
	emake \
		-C src \
		-f scripts/gcc.mak \
		CC="$(tc-getCC)" \
		GENTOO_CFLAGS="${CFLAGS}" \
		GENTOO_LDFLAGS="${LDFLAGS}" \
		|| die "emake failed"
}

src_install() {
	dobin src/optipng || die "dobin failed"
	dodoc README.txt doc/*.txt
	dohtml doc/*.html
	doman man/optipng.1
}
