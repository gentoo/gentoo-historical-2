# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/c-ares/c-ares-1.3.0.ebuild,v 1.5 2005/10/20 23:45:42 ka0ttic Exp $

DESCRIPTION="C library that resolves names asynchronously"
HOMEPAGE="http://daniel.haxx.se/projects/c-ares/"
SRC_URI="http://daniel.haxx.se/projects/c-ares/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 hppa ~mips ppc ~sparc ~x86"
IUSE=""

DEPEND=""

src_compile() {
	econf --enable-shared || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc CHANGES NEWS README*
}
