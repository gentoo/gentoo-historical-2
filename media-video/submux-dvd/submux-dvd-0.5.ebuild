# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/submux-dvd/submux-dvd-0.5.ebuild,v 1.1 2004/05/27 13:31:25 lordvan Exp $

DESCRIPTION="A subtitle multiplexer, muxes subtitles into .vob"
HOMEPAGE="http://home.zonnet.nl/panteltje/dvd/"
SRC_URI="http://home.zonnet.nl/panteltje/dvd/${P}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND=""
#RDEPEND=""

S=${WORKDIR}/${P}

src_unpack() {
	unpack ${P}.tgz
	# fix missing '\' 
	cd ${S}; epatch ${FILESDIR}/${P}.patch
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	# just 2 files not worth a makefile patch
	dobin submux-dvd vob2sub
	dodoc CHANGES FORMAT INSTALL LICENSE README submux-dvd-0.5.lsm
	dohtml spu.html
	doman submux-dvd.man
}
