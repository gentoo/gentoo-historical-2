# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/dvmysql/dvmysql-0.4.8.ebuild,v 1.5 2004/06/24 23:06:46 agriffis Exp $

inherit eutils

DESCRIPTION="dvmysql provides a C++ interface to mysql"
HOMEPAGE="http://tinf2.vub.ac.be/~dvermeir/software/dv/dvmysql/html/"
SRC_URI="http://tinf2.vub.ac.be/~dvermeir/software/dv/dvmysql/download/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc"

IUSE=""

DEPEND="virtual/glibc
	dev-db/mysql
	dev-libs/dvutil"

src_install() {
	make prefix=${D}/usr datadir=${D}/usr/share install
}
