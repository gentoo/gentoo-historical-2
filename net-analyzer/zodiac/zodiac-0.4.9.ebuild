# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/zodiac/zodiac-0.4.9.ebuild,v 1.4 2004/07/10 09:51:52 eldad Exp $

DESCRIPTION="DNS protocol analyzer"
HOMEPAGE="http://www.packetfactory.net/projects/zodiac/"
SRC_URI="http://www.packetfactory.net/projects/zodiac/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86"

DEPEND="sys-libs/ncurses
	=net-libs/libnet-1.0*
	net-libs/libpcap"

S=${WORKDIR}/${PN}
IUSE=""

src_compile() {
	cd src
	emake CFLAGS="${CFLAGS} `libnet-config --defines` -D_REENTRANT -pthread" || die
}

src_install() {
	dobin zodiac
	mv README{,.dev}
	dodoc README.dev doc/*
	dodir /usr/share/${PF}-src
	cd src && make clean
	cp -rf * ${D}/usr/share/${PF}-src
}
