# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/nap/nap-1.5.4.ebuild,v 1.3 2007/03/15 20:39:25 mabi Exp $

IUSE=""
DESCRIPTION="Console Napster/OpenNap client"
HOMEPAGE="http://www.mathstat.dal.ca/~selinger/nap/"
SRC_URI="http://www.mathstat.dal.ca/~selinger/nap/dist/${P}.tar.gz"

SLOT="0"
KEYWORDS="ppc x86"
LICENSE="as-is"

RDEPEND="virtual/libc"

src_compile() {
	./configure --prefix=${D}/usr || die "configure problem"
	emake || die "compile problem"
}

src_install() {
	emake install || die "install problem"

	dodoc AUTHORS COPYRIGHT COPYING ChangeLog NEWS README
}
