# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/iax/iax-0.2.2.ebuild,v 1.4 2004/06/24 23:11:29 agriffis Exp $

IUSE=""

DESCRIPTION="IAX (Inter Asterisk eXchange) Library"
HOMEPAGE="http://www.digium.com/"
LICENSE="LGPL-2"
DEPEND="virtual/glibc"
RDEPEND="virtual/glibc"
SLOT="0"
SRC_URI="http://www.digium.com/pub/libiax/${P}.tar.gz"

S=${WORKDIR}/${P}

D_PREFIX=/usr

KEYWORDS="x86 ~ppc"

src_compile() {
	./configure --prefix=${D_PREFIX} --enable-autoupdate

	export UCFLAGS="${CFLAGS}"

	emake || die
}

src_install () {
	make prefix=${D}/${D_PREFIX} install
	dodoc NEWS COPYING AUTHORS README
}
