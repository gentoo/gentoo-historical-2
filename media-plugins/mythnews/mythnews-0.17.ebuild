# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/mythnews/mythnews-0.17.ebuild,v 1.1 2005/02/11 15:47:48 cardoe Exp $

inherit myth

DESCRIPTION="RSS feed news reading module for MythTV."
HOMEPAGE="http://www.mythtv.org/"
SRC_URI="http://www.mythtv.org/mc/${P}.tar.bz2"
IUSE=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND=">=sys-apps/sed-4
	|| ( ~media-tv/mythtv-${PV} ~media-tv/mythfrontend-${PV} )"

setup_pro() {
	return 0
}
