# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/vlock/vlock-1.3.ebuild,v 1.10 2004/06/24 22:37:35 agriffis Exp $

DESCRIPTION="A console screen locker"
SRC_URI="ftp://ftp.ibiblio.org/pub/Linux/utils/console/vlock-1.3.tar.gz"
HOMEPAGE="ftp://ftp.ibiblio.org/pub/Linux/utils/console/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"
IUSE=""

DEPEND="virtual/glibc"

src_compile() {
	make RPM_OPT_FLAGS="${CFLAGS}" || die
}

src_install() {
	dobin vlock
	doman vlock.1
	dodoc COPYING README
}
