# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libol/libol-0.2.23.ebuild,v 1.14 2002/12/09 04:21:03 manson Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Support library for syslog-ng"
SRC_URI="http://www.balabit.hu/downloads/libol/0.2/${P}.tar.gz"
HOMEPAGE="http://www.balabit.hu/en/products/syslog-ng/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc "
IUSE=""

DEPEND="virtual/glibc"

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
