# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/poink/poink-2.03.ebuild,v 1.4 2005/08/29 20:10:36 dang Exp $

inherit eutils toolchain-funcs

DESCRIPTION="TCP/IP-based ping implementation"
HOMEPAGE="http://directory.fsf.org/security/system/poink.html"
SRC_URI="http://ep09.pld-linux.org/~mmazur/poink/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
DEPEND="virtual/libc"

src_compile() {
	emake CFLAGS="${CFLAGS}" CC="$(tc-getCC)" || die
}

src_install() {
	dobin poink poink6
	newman ping.1 poink.1
	dodoc README* ChangeLog COPYING
}
