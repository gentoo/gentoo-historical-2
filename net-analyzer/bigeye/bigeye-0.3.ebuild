# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/bigeye/bigeye-0.3.ebuild,v 1.3 2003/02/13 13:39:15 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Bigeye is a network utility dump and simple honeypot utility"
HOMEPAGE="http://violating.us/projects/bigeye/"
SRC_URI="http://violating.us/projects/bigeye/download/${P}.tgz"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND="virtual/glibc"

src_compile() {

	cd ${S}/src
	gcc ${CFLAGS} bigeye.c emulate.c -o bigeye -W

}

src_install() {

	dobin src/bigeye

	dodir /usr/share/bigeye/messages
	insinto /usr/share/bigeye
	doins sig.file

	cp -r messages/* ${D}/usr/share/bigeye/messages

	dodoc README

}

pkg_postinst() {

	einfo
	einfo The service emulation files mentioned in the README are located in
	einfo /usr/share/bigeye/messages.
	einfo

}

