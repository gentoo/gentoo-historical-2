# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/submux-dvd/submux-dvd-0.5.ebuild,v 1.5 2004/08/09 20:16:05 slarti Exp $

inherit eutils

DESCRIPTION="A subtitle multiplexer, muxes subtitles into .vob"
HOMEPAGE="http://home.zonnet.nl/panteltje/dvd/"
SRC_URI="http://home.zonnet.nl/panteltje/dvd/${P}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
DEPEND=""

src_unpack() {
	unpack ${A}
	# fix missing '\' 
	cd ${S}; epatch ${FILESDIR}/${P}.patch
}

src_compile() {
	emake CC=$CC || die "emake failed"
}

src_install() {
	# just 2 files not worth a makefile patch
	dobin submux-dvd vob2sub
	dodoc CHANGES FORMAT INSTALL LICENSE README submux-dvd-0.5.lsm submux-dvd.man
	dohtml spu.html
}
