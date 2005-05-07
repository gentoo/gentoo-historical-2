# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/httping/httping-0.0.94-r1.ebuild,v 1.3 2005/05/07 21:28:09 vanquirius Exp $

DESCRIPTION="http protocol ping-like program"
HOMEPAGE="http://www.vanheusden.com/httping/"
SRC_URI="http://www.vanheusden.com/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ppc64"
IUSE="ssl"

DEPEND=">=sys-libs/ncurses-5"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i -e "s:CFLAGS=:CFLAGS=${CFLAGS} :g" Makefile*
}

src_compile() {
	use ssl && emake || die "make failed"
	use ssl || emake -f Makefile.nossl || die "make failed"
}

src_install() {
	dobin httping
	dodoc readme.txt license.txt
}
