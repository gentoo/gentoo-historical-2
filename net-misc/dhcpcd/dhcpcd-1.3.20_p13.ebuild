# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/dhcpcd/dhcpcd-1.3.20_p13.ebuild,v 1.1 2002/10/29 13:49:05 lostlogic Exp $

MYV=1.3.22-pl3
S=${WORKDIR}/${PN}-${MYV}
DESCRIPTION="A dhcp client only"
SRC_URI="ftp://ftp.phystech.com/pub/${PN}-${MYV}.tar.gz"
HOMEPAGE="http://www.phystech.com/download/"
DEPEND=""
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~sparc64 ~alpha"
LICENSE="GPL-2"

src_compile() {
	./configure --prefix=/ --mandir=/usr/share/man --sysconfdir=/etc --sbindir=/sbin --host=${CHOST} || die
	make || die
}

src_install () {
	make DESTDIR=${D} install || die
	if [ -z "`use build`" ]
	then
		dodoc AUTHORS COPYING ChangeLog NEWS README 
	else
		rm -rf ${D}/usr/share
	fi
	insinto /etc/pcmcia
	doins pcmcia/network*
}
