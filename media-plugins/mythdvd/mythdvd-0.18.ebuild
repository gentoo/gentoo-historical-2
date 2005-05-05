# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/mythdvd/mythdvd-0.18.ebuild,v 1.2 2005/05/05 23:15:06 swegener Exp $

inherit myth

DESCRIPTION="DVD player module for MythTV."
HOMEPAGE="http://www.mythtv.org/"
SRC_URI="http://www.mythtv.org/mc/mythplugins-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="transcode"

RDEPEND=">=media-plugins/mythvideo-${PV}
	media-libs/libdvdread
	|| ( ~media-tv/mythtv-${PV} ~media-tv/mythfrontend-${PV} )"

DEPEND=">=sys-apps/sed-4
	${RDEPEND}"

RDEPEND="${RDEPEND}
	 transcode? ( media-video/transcode )
	 || ( media-video/mplayer media-video/xine-ui media-video/ogle )"

setup_pro() {
	return 0
}

src_compile() {
	myconf="--enable-vcd $(use_enable transcode)"

	myth_src_compile || die "failed to compile"
}
