# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/pngcrush/pngcrush-1.6.7.ebuild,v 1.3 2008/08/23 17:40:51 maekke Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Portable Network Graphics (PNG) optimizing utility"
HOMEPAGE="http://pmt.sourceforge.net/pngcrush"
SRC_URI="mirror://debian/pool/main/p/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc x86"
IUSE=""

DEPEND=">=media-libs/libpng-1.2.26-r1"

S=${WORKDIR}/${P}-nolib

src_unpack() {
	unpack ${A}
	cd "${S}"
	# Use system libpng, fix various bugs and sanitize Makefile
	epatch "${FILESDIR}"/${P}-modified_debian_patchset_1.patch
}

src_compile() {
	tc-export CC
	emake || die "emake failed."
}

src_install() {
	dobin ${PN} || die "dobin failed."
	dodoc *.txt
}
