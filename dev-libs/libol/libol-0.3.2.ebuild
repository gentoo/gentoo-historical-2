# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Bruce Locke <blocke@shivan.org>
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libol/libol-0.3.2.ebuild,v 1.1 2002/05/22 02:23:21 blocke Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Support library for syslog-ng"
SRC_URI="http://www.balabit.hu/downloads/libol/0.3/${P}.tar.gz"
HOMEPAGE="http://www.balabit.hu/en/products/syslog-ng/"
SLOT="0"
LICENSE="GPL"

DEPEND=""

src_compile() {

	econf --enable-shared --enable-static --disable-libtool-lock || die
	emake CFLAGS="${CFLAGS}" all || die
}

src_install() {

	einstall || die
	dodoc ChangeLog 
}
