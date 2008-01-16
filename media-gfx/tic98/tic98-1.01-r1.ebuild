# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/tic98/tic98-1.01-r1.ebuild,v 1.6 2008/01/16 23:59:59 maekke Exp $

inherit eutils

DESCRIPTION="compressor for black-and-white images, in particular scanned documents"
HOMEPAGE="http://www.cs.waikato.ac.nz/~singlis/"
SRC_URI="http://www.cs.waikato.ac.nz/~singlis/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc-macos x86"
IUSE=""

DEPEND=""

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}/${P}"-macos.patch
	cd "${S}"
	epatch "${FILESDIR}/${P}"-gentoo.diff
}

src_compile() {
	emake all || die
	emake all2 || die
}

src_install() {
	dodir /usr/bin
	emake BIN="${D}"usr/bin install || die
}
