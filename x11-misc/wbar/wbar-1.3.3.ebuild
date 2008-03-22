# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/wbar/wbar-1.3.3.ebuild,v 1.3 2008/03/22 10:43:26 maekke Exp $

inherit eutils toolchain-funcs

DESCRIPTION="a (fast, light, and cool eye-candy) quick launch bar."
HOMEPAGE="http://www.tecnologia-aplicada.com.ar/rodolfo"
SRC_URI="http://www.tecnologia-aplicada.com.ar/rodolfo/${P}.tbz2
	http://www.tecapli.com.ar/rodolfo/${P}.tbz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND="media-libs/imlib2
	x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-proto/xproto"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-Makefile.patch
}

src_compile() {
	emake CXX="$(tc-getCXX)" || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS NEWS README
}
