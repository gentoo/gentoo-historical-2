# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/dvnet/dvnet-0.9.8.ebuild,v 1.9 2004/07/02 04:38:13 eradicator Exp $

DESCRIPTION="dvnet provides an interface wrapping sockets into streams"
HOMEPAGE="http://tinf2.vub.ac.be/~dvermeir/software/dv/dvnet/html/"
SRC_URI="http://tinf2.vub.ac.be/~dvermeir/software/dv/dvnet/download/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"

IUSE=""

DEPEND="virtual/libc
	dev-libs/dvutil"

src_install() {
	make DESTDIR=${D} prefix=${D}/usr install
}
