# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/zh-kcfonts/zh-kcfonts-1.05.ebuild,v 1.2 2002/11/06 15:36:48 vapier Exp $

KCFONTS="zh-kcfonts-1.05.tgz"

DESCRIPTION="Kuo Chauo Chinese Fonts collection in BIG5 encoding"
SRC_URI="ftp://ftp.freebsd.org.tw/pub/i386/4.6.2-RELEASE/packages/x11-fonts/${P}.tgz"
HOMEPAGE=""	#No homepage exists that I am aware of or able to find

LICENSE="freedist"
SLOT="0"
KEYWORDS="~x86"

DEPEND="x11-base/xfree"
S=${WORKDIR}/${PN}
CFONTDIR=/usr/X11R6/lib/X11/fonts/misc/

src_unpack() {
	mkdir ${S}
	cd ${S}
	unpack ${A}
}

src_install() {
	dodir ${CFONTDIR}
	insinto ${CFONTDIR}
	doins ${S}/lib/X11/fonts/local/*
}

pkg_postinst() {
	mkfontdir ${CFONTDIR}
	cd ${CFONTDIR}
	cat kc_fonts.alias >> fonts.alias ; 
	cp fonts.alias ..fonts.alias.. ;
	sort ..fonts.alias.. | uniq > fonts.alias ; rm ..fonts.alias..
}
