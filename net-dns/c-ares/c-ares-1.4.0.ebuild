# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/c-ares/c-ares-1.4.0.ebuild,v 1.3 2007/06/09 12:04:40 angelos Exp $

DESCRIPTION="C library that resolves names asynchronously"
HOMEPAGE="http://daniel.haxx.se/projects/c-ares/"
SRC_URI="http://daniel.haxx.se/projects/c-ares/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc-macos ppc64 ~s390 ~sh ~sparc ~x86"
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
