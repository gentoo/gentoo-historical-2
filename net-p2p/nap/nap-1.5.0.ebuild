# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/nap/nap-1.5.0.ebuild,v 1.5 2003/02/13 15:21:42 vapier Exp $

S="${WORKDIR}/${P}"
DESCRIPTION="Console Napster/OpenNap client"
HOMEPAGE="http://quasar.mathstat.uottawa.ca/~selinger/nap/"
SRC_URI="http://quasar.mathstat.uottawa.ca/~selinger/nap/${P}.tar.gz"
LICENSE="as-is"

RDEPEND="virtual/glibc"
DEPEND="${RDEPEND}"
SLOT="0"
KEYWORDS="x86 ppc"

src_compile() {
	./configure --prefix=${D}/usr || die "configure problem"
	emake || die "compile problem"
}

src_install() {
	emake install || die "install problem"

	dodoc AUTHORS COPYRIGHT COPYING ChangeLog NEWS README
}
