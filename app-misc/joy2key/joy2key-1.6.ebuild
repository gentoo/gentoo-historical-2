# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/joy2key/joy2key-1.6.ebuild,v 1.9 2002/10/17 00:14:17 vapier Exp $

IUSE="X"

S=${WORKDIR}/${P}
DESCRIPTION="An application that translates joystick events to keyboard events"
SRC_URI="http://www-unix.oit.umass.edu/~tetron/technology/joy2key/${P}.tar.gz"
HOMEPAGE="http://www-unix.out.umass.edu/~tetron/technology/joy2key/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND="X? ( virtual/x11 )"
RDEPEND="${DEPEND}"

src_compile() {
	local myconf
	use X || myconf="--disable-X"

	CFLAGS=${CFLAGS/-O?/}
	econf ${myconf} || die
	make || die
}

src_install() {
	dobin joy2key
	doman joy2key.1
	dodoc README joy2keyrc.sample AUTHORS NEWS TODO
}
