# Copyright 2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/sys-apps/mawk/mawk-1.3.3.ebuild,v 1.1 2003/06/08 20:47:22 lostlogic Exp $

DESCRIPTION="An (often faster than gawk) awk-interpreter."
SRC_URI="ftp://ftp.whidbey.net/pub/brennan/${P}.tar.gz"
HOMEPAGE="not avail -- use SRC_URI"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~hppa"

DEPEND="virtual/glibc"
IUSE=""

src_compile() {
	./configure --prefix=/usr || die "Failed to configure"
	MAKEOPTS="${MAKEOPTS} -j1" emake || die "Make failed"
}

src_install () {
	dodir /usr/bin /usr/share/man/man1
	make BINDIR=${D}/usr/bin \
	     MANDIR=${D}/usr/share/man/man1 \
	     install || die "Install failed"
	dodoc ACKNOWLEDGMENT CHANGES COPYING INSTALL README
}
