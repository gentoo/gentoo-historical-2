# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/p0f/p0f-1.8.2.ebuild,v 1.5 2002/07/18 23:22:51 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="p0f performs passive OS detection based on SYN packets."
SRC_URI="http://www.stearns.org/p0f/p0f-1.8.2.tgz"
DEPEND="net-libs/libpcap"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="x86"

src_compile() {
	patch < ${FILESDIR}/${P}-makefile.patch
	cp ${FILESDIR}/${P}.rc p0f.rc
	make || die
}

src_install () {
	mkdir -p ${D}/usr/bin
	mkdir -p ${D}/usr/sbin
	mkdir -p ${D}/usr/share/doc
	mkdir -p ${D}/usr/share/man/man1
	mkdir -p ${D}/etc/init.d
	make DESTDIR=${D} install
}

pkg_postinst () {
	einfo "You can start the p0f monitoring program on boot time by running"
	einfo "rc-update add p0f default"
}
