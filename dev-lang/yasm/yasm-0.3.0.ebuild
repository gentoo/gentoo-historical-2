# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/yasm/yasm-0.3.0.ebuild,v 1.4 2004/06/24 22:59:07 agriffis Exp $

DESCRIPTION="assembler that supports amd64"
HOMEPAGE="http://www.tortall.net/projects/yasm/"
SRC_URI="http://www.tortall.net/projects/yasm/releases/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-* ~x86 ~amd64"
IUSE=""

DEPEND="sys-devel/gcc"

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS COPYING INSTALL Artistic.txt BSD.txt
}
