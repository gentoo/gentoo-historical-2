# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/dhcpcd/dhcpcd-1.3.22_p3-r1.ebuild,v 1.2 2002/11/12 22:17:21 wwoods Exp $

inherit gnuconfig

S=${WORKDIR}/${P/_p/-pl}
DESCRIPTION="A dhcp client only"
SRC_URI="ftp://ftp.phystech.com/pub/${P/_p/-pl}.tar.gz"
HOMEPAGE="http://www.phystech.com/download/"
DEPEND=""
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~sparc64 ~alpha"
LICENSE="GPL-2"

src_unpack() {
        unpack ${A} || die "unpack failed"
        use alpha && gnuconfig_update
}

src_compile() {
	econf || die "Configure failed"
	emake || die "Make failed"
}

src_install () {
	einstall sbindir=${D}/sbin || die "Install failed"
	if [ -z "`use build`" ]
	then
		dodoc AUTHORS COPYING ChangeLog NEWS README 
	else
		rm -rf ${D}/usr/share
	fi
	insinto /etc/pcmcia
	doins pcmcia/network*
}
