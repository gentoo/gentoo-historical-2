# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/krecord/krecord-1.11.ebuild,v 1.6 2004/04/20 17:24:58 eradicator Exp $

IUSE=""
inherit kde-base

DESCRIPTION="KDE sound recorder app"
HOMEPAGE="http://bytesex.org/krecord.html"
SRC_URI="http://bytesex.org/misc/${PN}_${PV}.tar.gz"
KEYWORDS="x86"
LICENSE="GPL-2"

need-kde 3

#RDEPEND="media-libs/alsa-lib"

src_install() {

	cd ${S}
	make prefix=${D}/${PREFIX} install

}
