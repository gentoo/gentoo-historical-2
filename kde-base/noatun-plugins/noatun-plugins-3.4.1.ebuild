# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/noatun-plugins/noatun-plugins-3.4.1.ebuild,v 1.3 2005/06/20 12:27:02 greg_g Exp $
KMNAME=kdeaddons
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="Various plugins for noatun"
KEYWORDS="~x86 ~amd64 ~ppc64 ~ppc ~sparc"
IUSE="arts sdl berkdb"
DEPEND="$(deprange-dual $PV $MAXKDEVER kde-base/noatun)
	arts? ( $(deprange $PV $MAXKDEVER kde-base/arts) )
	sdl? ( >=media-libs/libsdl-1.2 )
	berkdb? ( =sys-libs/db-4.2* )"

# This patch makes the configure test in noatun-oblique find db_cxx.h,
# but it also makes db support non-optional. should be fixed, ideally
if useq berkdb; then
	PATCHES="$FILESDIR/noatun-oblique-db-location-3.4.0_rc1.diff"
	myconf="--with-extra-includes=/usr/include/db4.2"
fi

