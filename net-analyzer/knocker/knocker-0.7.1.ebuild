# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/knocker/knocker-0.7.1.ebuild,v 1.10 2004/07/08 22:52:53 eldad Exp $

DESCRIPTION="Knocker is an easy to use security port scanner written in C"
SRC_URI="mirror://sourceforge/knocker/${P}.tar.gz"
HOMEPAGE="http://knocker.sourceforge.net"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc ~ppc"
IUSE=""

DEPEND="virtual/libc"

src_compile() {
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man || die "./configure failed"

	emake || die "emake died"
}

src_install () {
	make DESTDIR=${D} install || die

	dodoc ChangeLog AUTHORS README BUGS TO-DO NEWS
}
