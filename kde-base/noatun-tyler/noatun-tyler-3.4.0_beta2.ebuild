# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/noatun-tyler/noatun-tyler-3.4.0_beta2.ebuild,v 1.1 2005/02/05 11:39:27 danarmak Exp $
KMNAME=kdeaddons
KMNOMODULE=true
KMEXTRA="noatun-plugins/configure.in.in noatun-plugins/tyler"
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="noatun visualization plugin"
KEYWORDS="~x86"
IUSE=""
DEPEND=" >=media-libs/libsdl-1.2 $(deprange $PV $MAXKDEVER kde-base/noatun)"
OLDDEPEND=">=media-libs/libsdl-1.2 ~kde-base/noatun-$PV"

myconf="--with-sdl-prefix=/usr"
