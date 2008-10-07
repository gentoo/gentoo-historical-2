# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/alac_decoder/alac_decoder-0.1.3.ebuild,v 1.4 2008/10/07 12:56:23 nixnut Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Basic decoder for Apple Lossless Audio Codec files (ALAC)"
HOMEPAGE="http://craz.net/programs/itunes/alac.html"
SRC_URI="http://craz.net/programs/itunes/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""
DEPEND=""

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# add $LDFLAGS to link command
	sed -i -e "s:\(-o alac\):\$(LDFLAGS) \1:g" Makefile
}

src_compile() {
	emake CC=$(tc-getCC) CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	dobin alac || die "install failed"
	dodoc README
}
