# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/zodiac/zodiac-0.4.9-r1.ebuild,v 1.3 2003/11/10 14:45:33 vapier Exp $

inherit eutils

DESCRIPTION="DNS protocol analyzer"
HOMEPAGE="http://www.packetfactory.net/projects/zodiac/"
SRC_URI="http://www.packetfactory.net/projects/zodiac/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86"

DEPEND="sys-libs/ncurses
	<net-libs/libnet-1.1
	>=net-libs/libnet-1.0.2a-r3
	net-libs/libpcap"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd ${S}/src
	epatch ${FILESDIR}/${PV}-libnet-1.0.patch
	sed -i \
		-e "s:-g -ggdb -DDEBUG:${CFLAGS}:" \
		-e 's:-static::' \
		Makefile
}

src_compile() {
	cd src
	emake || die
}

src_install() {
	dobin zodiac
	mv README{,.dev}
	dodoc README.dev doc/*
	dodir /usr/share/${PF}-src
	cd src && make clean
	cp -rf * ${D}/usr/share/${PF}-src
}
