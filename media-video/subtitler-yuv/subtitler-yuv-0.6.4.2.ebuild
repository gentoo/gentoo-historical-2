# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/subtitler-yuv/subtitler-yuv-0.6.4.2.ebuild,v 1.4 2004/06/25 00:50:31 agriffis Exp $

inherit eutils

DESCRIPTION="for mjpegtools for adding subtitles, pictures, and effects embedded in the picture"
HOMEPAGE="http://home.zonnet.nl/panteltje/subtitles/"
SRC_URI="http://home.zonnet.nl/panteltje/subtitles/${P}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""
DEPEND="virtual/x11"

src_unpack() {
	unpack ${A}
	# fix missing '\' 
	cd ${S}; epatch ${FILESDIR}/${P}.patch
}

src_compile() {
	emake CFLAGS="$CFLAGS" || die "emake failed"
}

src_install() {
	dobin subtitler-yuv
	dodoc CHANGES HOWTO_USE_THIS LICENSE README README.COLOR.PROCESSOR README.PPML
	insinto /usr/share/${PN}
	doins demo-yuv.ppml rose.ppm sun.ppm mp-arial-iso-8859-1.zip
}
