# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/linux-identd/linux-identd-1.2.ebuild,v 1.1 2002/10/12 10:11:39 blizzy Exp $

# This identd is nearly perfect for a NAT box. It runs in one
# process (doesn't fork()) and isnt very susceptible to DOS attack.

DESCRIPTION="A real IDENT daemon for linux."
HOMEPAGE="http://www.fukt.bth.se/~per/identd"
S=${WORKDIR}/${P}
SRC_URI="http://www.fukt.bth.se/~per/identd/${P}.tar.gz"
KEYWORDS="x86 sparc sparc64"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="virtual/glibc"

src_compile() {
	cd ${S}
        emake || die
}

src_install () {
	dodir /etc/init.d /usr/sbin /usr/share/man/man8
	dodoc README COPYING ChangeLog
	make install DESTDIR=${D} MANDIR=/usr/share/man || die
	cp ${FILESDIR}/identd ${D}/etc/init.d
}
