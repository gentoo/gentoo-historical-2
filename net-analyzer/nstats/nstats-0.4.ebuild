# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nstats/nstats-0.4.ebuild,v 1.3 2002/09/23 20:00:25 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Displays statistics about ethernet traffic including protocol breakdown"
SRC_URI="http://trash.net/~reeler/nstats/files/${P}.tar.gz"
HOMEPAGE="http://trash.net/~reeler/nstats/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 sparc sparc64"

DEPEND=">=net-libs/libpcap-0.7.1"

src_compile() {
	econf || die "./configure failed"
	make || die "make failed"
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc BUGS COPYING doc/TODO doc/ChangeLog
}
