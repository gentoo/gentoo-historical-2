# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libol/libol-0.3.13.ebuild,v 1.2 2004/03/14 12:22:29 mr_bones_ Exp $

DESCRIPTION="Support library for syslog-ng"
SRC_URI="http://www.balabit.hu/downloads/libol/0.3/${P}.tar.gz"
HOMEPAGE="http://www.balabit.hu/en/products/syslog-ng/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~hppa ~mips ~amd64 ~ia64"
IUSE=""

DEPEND="virtual/glibc"
RDEPEND=""

src_compile() {
	econf \
		--enable-shared \
		--enable-static \
		--disable-libtool-lock || die
	emake CFLAGS="${CFLAGS}" all || die
}

src_install() {
	einstall || die
	dodoc ChangeLog
}
