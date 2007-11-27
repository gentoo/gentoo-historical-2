# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/dxr3config/dxr3config-0.3.2.ebuild,v 1.5 2007/11/27 11:46:38 zzam Exp $

MY_PV="${PV/./-}"
MY_P="${PN}${MY_PV/./-}"

DESCRIPTION="a small tool, which helps you to find the appropriate module parameters for a dxr3-mpeg card."
HOMEPAGE="http://free.pages.at/wicky4vdr"
SRC_URI="http://free.pages.at/wicky4vdr/download/${MY_P}.tgz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-util/dialog
	media-video/em8300-modules"

S=${WORKDIR}

src_unpack() {
	unpack ${A}

	cd "${S}"
	sed -i -e 's:DIST="debian":DIST="gentoo":' usr/sbin/${PN}
}

src_install() {
	newsbin usr/sbin/${PN} ${PN}
	insinto /usr/share/${PN}
	doins usr/share/${PN}/${PN}.m2v
}
