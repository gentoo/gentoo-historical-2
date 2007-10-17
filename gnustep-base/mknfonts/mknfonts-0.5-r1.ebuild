# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-base/mknfonts/mknfonts-0.5-r1.ebuild,v 1.6 2007/10/17 17:45:16 opfer Exp $

inherit eutils gnustep-base

DESCRIPTION="A tool to create .nfont packages for use with gnustep-back-art."

HOMEPAGE="http://packages.debian.org/mknfonts.tool"
SRC_URI="mirror://debian/pool/main/m/${PN}.tool/${PN}.tool_${PV}.orig.tar.gz"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc x86"
SLOT="0"
LICENSE="GPL-2"

DEPEND="gnustep-base/gnustep-gui
	>=media-libs/freetype-2.1"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${PN}-rename.patch
}
