# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/bcm2835/bcm2835-1.30.ebuild,v 1.1 2013/10/22 11:39:40 chithanh Exp $

EAPI=4

DESCRIPTION="Provides access to GPIO and other IO functions on the Broadcom BCM2835"
HOMEPAGE="http://www.airspayce.com/mikem/bcm2835/"
SRC_URI="http://www.airspayce.com/mikem/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm"
IUSE="doc examples"

DEPEND="doc? ( app-doc/doxygen )"
RDEPEND=""

src_install() {
	default
	if use examples; then
		dodoc -r examples
	fi
	if use doc; then
		dohtml -r doc/html/.
	fi
}
