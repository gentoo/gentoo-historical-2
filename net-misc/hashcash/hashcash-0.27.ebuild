# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/hashcash/hashcash-0.27.ebuild,v 1.4 2004/07/01 21:06:36 squinky86 Exp $

IUSE=""
DESCRIPTION="Utility to generate hashcash tokens"
HOMEPAGE="http://www.cypherspace.org/hashcash/"
SRC_URI="http://www.cypherspace.org/hashcash/source/${P}.tgz"

LICENSE="CPL-1.0"
SLOT="0"
KEYWORDS="~x86"

DEPEND="virtual/libc"
RDEPEND=""

src_compile() {
	sed -i \
		-e "s|^CFLAGS.*\$|CFLAGS = ${CFLAGS}|" \
		-e "s|^INSTALL_PATH.*\$|INSTALL_PATH = \$(PREFIX)/bin|" \
		-e "s|^MAN_INSTALL_PATH.*\$|MAN_INSTALL_PATH = \$(PREFIX)/share/man/man1|" \
		Makefile || die

	emake || die
}

src_install() {
	dosbin hashcash
	doman hashcash.1 sha1.1
}
