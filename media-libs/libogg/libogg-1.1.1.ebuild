# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libogg/libogg-1.1.1.ebuild,v 1.6 2005/02/05 10:46:46 hansmi Exp $

inherit gnuconfig

DESCRIPTION="the Ogg media file format library"
HOMEPAGE="http://www.xiph.org/ogg/vorbis/index.html"
SRC_URI="http://downloads.xiph.org/releases/ogg/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ppc-macos ~sparc ~x86"
IUSE=""

DEPEND="virtual/libc"

src_unpack() {
	unpack ${A}
	cd "${S}"
	gnuconfig_update
}

src_install () {
	make DESTDIR="${D}" install || die "make install failed"

	# remove the docs installed by make install, since I'll install
	# them in portage package doc directory
	rm -rf "${D}/usr/share/doc"

	dodoc AUTHORS CHANGES README
	dohtml doc/*.{html,png}
}