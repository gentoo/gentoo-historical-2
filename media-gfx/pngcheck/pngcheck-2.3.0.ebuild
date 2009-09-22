# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/pngcheck/pngcheck-2.3.0.ebuild,v 1.3 2009/09/22 13:50:40 maekke Exp $

inherit toolchain-funcs

DESCRIPTION="verifies the integrity of PNG, JNG and MNG files with internal checksums"
HOMEPAGE="http://www.libpng.org/pub/png/apps/pngcheck.html"
SRC_URI="mirror://sourceforge/png-mng/${P}.tar.gz"

LICENSE="as-is GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-libs/zlib"

src_compile() {
	emake -f Makefile.unx CC="$(tc-getCC)" \
		CFLAGS="${LDFLAGS} ${CFLAGS} -DUSE_ZLIB" \
		ZLIB="-lz" || die "emake failed."
}

src_install() {
	dobin ${PN} pngsplit png-fix-IDAT-windowsize || die "dobin failed."
	dodoc CHANGELOG README
}
