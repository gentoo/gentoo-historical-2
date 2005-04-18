# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/mythphone/mythphone-0.16.ebuild,v 1.5 2005/04/18 08:18:00 eradicator Exp $

inherit myth eutils

DESCRIPTION="Phone and video calls with SIP."
HOMEPAGE="http://www.mythtv.org/"
SRC_URI="http://www.mythtv.org/mc/${P}.tar.bz2"
IUSE="debug nls"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64"

DEPEND=">=sys-apps/sed-4
	|| ( ~media-tv/mythtv-${PV} ~media-tv/mythfrontend-${PV} )"

setup_pro() {
	return 0
}

src_unpack() {
	myth_src_unpack

	epatch ${FILESDIR}/${P}-include.patch
}

src_compile() {
	econf || die

	# currently broken, #64503
	#`use_enable festival`

	myth_src_compile
}
