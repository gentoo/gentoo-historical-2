# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/physfs/physfs-1.1.0.ebuild,v 1.4 2007/04/24 15:49:00 drizzt Exp $

DESCRIPTION="abstraction layer for filesystems, useful for games"
HOMEPAGE="http://icculus.org/physfs/"
SRC_URI="http://icculus.org/physfs/downloads/${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="-* ~x86-fbsd"
IUSE=""

DEPEND="sys-libs/zlib"

src_compile() {
	# the test prog is not used by src_test() or installed,
	# so lets just punt it and be done
	econf \
		--disable-testprog \
		--disable-internal-zlib \
		|| die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc CHANGELOG CREDITS TODO docs/README
}
