# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/ogmtools/ogmtools-0.954.ebuild,v 1.1 2002/11/17 09:17:03 phoenix Exp $

IUSE=""

DESCRIPTION="These tools allow information about (ogminfo) or extraction from (ogmdemux) or creation of (ogmmerge) OGG media streams."
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
HOMEPAGE="http://www.bunkus.org/videotools/ogmtools/"
SRC_URI="http://www.bunkus.org/videotools/${PN}/${P}.tar.bz2"

DEPEND="media-sound/vorbis-tools"


src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	into /usr
	dobin ogmmerge ogmdemux ogminfo ogmsplit ogmcat dvdxchap
	into /usr/share
	doman man1/ogmsplit.1 man1/ogminfo.1 man1/ogmmerge.1 man1/ogmdemux.1 man1/ogmcat.1 man1/dvdxchap.1
}
