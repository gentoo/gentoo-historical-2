# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/raccess/raccess-0.7.ebuild,v 1.3 2004/07/15 03:21:57 agriffis Exp $

DESCRIPTION="Remote Access Session is an systems security analyzer"
HOMEPAGE="http://salix.org/raccess/"
SRC_URI="http://salix.org/raccess/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc"
IUSE=""

DEPEND="net-libs/libpcap"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i '/^BINFILES/s:@bindir@:/usr/lib/raccess:' src/Makefile.in
	sed -i '/^bindir/s:@bindir@/exploits:/usr/lib/raccess:' exploits/Makefile.in
}

src_compile() {
	econf --sysconfdir=/etc/raccess || die
	emake || die
}

src_install() {
	make install DESTDIR=${D} || die
	dodoc AUTHORS ChangeLog NEWS PROJECT_PLANNING README
}
