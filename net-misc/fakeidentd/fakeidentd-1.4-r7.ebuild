# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author: Donny Davies <woodchip@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-misc/fakeidentd/fakeidentd-1.4-r7.ebuild,v 1.1 2002/04/01 19:51:09 woodchip Exp $

# This identd is nearly perfect for a NAT box. It runs in one
# process (doesn't fork()) and isnt very susceptible to DOS attack.

DESCRIPTION="A static, secure identd. One source file only!"
HOMEPAGE="http://www.ajk.tele.fi/~too/sw"
S=${WORKDIR}/${P}
SRC_URI="http://www.ajk.tele.fi/~too/sw/releases/identd.c
         http://www.ajk.tele.fi/~too/sw/identd.readme"

DEPEND="virtual/glibc"

src_unpack() {
	mkdir ${P} ; cd ${S}
	cp ${DISTDIR}/identd.c ${DISTDIR}/identd.readme .
	mv identd.c identd.c.orig
	sed -e "s:identd.pid:fakeidentd.pid:" \
		identd.c.orig > identd.c
}

src_compile() {
	cd ${S}
	gcc identd.c -o ${PN} ${CFLAGS} || die
}

src_install () {
	dosbin ${PN}
	dodoc identd.readme
	# Changelog in source is more current. Its only ~13kB anyway.
	dodoc identd.c

	insinto /etc/conf.d
	newins ${FILESDIR}/fakeidentd.confd fakeidentd
	exeinto /etc/init.d
	newexe ${FILESDIR}/fakeidentd.rc6 fakeidentd
}
