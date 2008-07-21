# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-libs/popplerkit/popplerkit-0.2.ebuild,v 1.8 2008/07/21 08:42:51 voyageur Exp $

inherit gnustep-2

S="${WORKDIR}/Etoile-${PV}/Frameworks/PopplerKit"

DESCRIPTION="PopplerKit is a GNUstep/Cocoa framework for accessing and rendering PDF content."
HOMEPAGE="http://www.etoile-project.org"
SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86"
SLOT="0"

RDEPEND=">=app-text/poppler-0.4
	>=media-libs/freetype-2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-poppler6_support.patch
}
