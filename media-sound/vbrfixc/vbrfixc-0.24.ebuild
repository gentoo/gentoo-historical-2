# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/vbrfixc/vbrfixc-0.24.ebuild,v 1.4 2008/06/29 10:15:48 loki_val Exp $

inherit eutils

DESCRIPTION="Vbrfix fixes MP3s and re-constructs VBR headers"
HOMEPAGE="http://www.willwap.co.uk/Programs/vbrfix.php"
SRC_URI="http://www.willwap.co.uk/Downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
DEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"

	# every bigendian arch needs this patch
	#use ppc && epatch "${FILESDIR}/${P}-bigendian.diff"
	epatch "${FILESDIR}"/${P}-gcc43.patch

}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS README TODO
	dohtml vbrfixc/docs/en/*.html
}
