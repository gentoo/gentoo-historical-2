# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/ogmtools/ogmtools-1.3.ebuild,v 1.2 2004/04/16 13:34:10 lu_zero Exp $

DESCRIPTION="These tools allow information about (ogminfo) or extraction from (ogmdemux) or creation of (ogmmerge) OGG media streams"
HOMEPAGE="http://www.bunkus.org/videotools/ogmtools/"
SRC_URI="http://www.bunkus.org/videotools/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE="dvd"

RDEPEND="dvd? ( media-libs/libdvdread )
	media-sound/vorbis-tools"

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${P}-endian-fix.patch
}

src_compile() {
	econf `use_with dvd dvdread` || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	dobin ogmmerge ogmdemux ogminfo ogmsplit ogmcat || die
	use dvd && dobin dvdxchap
	dodoc INSTALL TODO README ChangeLog
	doman dvdxchap.1 ogmcat.1 ogmdemux.1 ogminfo.1 ogmmerge.1 ogmsplit.1
}
