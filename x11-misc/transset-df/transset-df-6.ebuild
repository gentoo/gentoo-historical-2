# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/transset-df/transset-df-6.ebuild,v 1.3 2008/01/09 15:26:28 angelos Exp $

DESCRIPTION="a patched version of xorg's transset"
HOMEPAGE="http://forchheimer.se/transset-df/"
SRC_URI="http://forchheimer.se/${PN}/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXfixes
	x11-libs/libXrender"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	x11-proto/xproto"

src_install() {
	dobin transset-df
	dodoc ChangeLog README
}
