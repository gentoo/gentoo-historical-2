# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/media-video/recmpeg/recmpeg-1.0.5.ebuild,v 1.2 2002/11/20 21:38:55 phoenix Exp $

IUSE="mmx sse"

DESCRIPTION="recmpeg is a simple video encoder, based on libfame, which compresses raw video sequences to MPEG video"
SRC_URI="mirror://sourceforge/fame/${P}.tar.gz"
HOMEPAGE="http://fame.sourceforge.net"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

DEPEND="virtual/glibc
	>=media-libs/libfame-0.9.0"

src_compile() {
	local myconf

	use mmx && myconf="${myconf} --enable-mmx"
	use sse && myconf="${myconf} --enable-sse"

	econf ${myconf} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	einstall install || die "einstall died"
	dodoc CHANGES README INSTALL NEWS
}
