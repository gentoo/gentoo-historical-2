# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeartwork-kscreensaver/kdeartwork-kscreensaver-3.4.0.ebuild,v 1.1 2005/03/13 21:19:01 danarmak Exp $

KMMODULE=kscreensaver
KMNAME=kdeartwork
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="Extra screensavers for kde"
KEYWORDS="~x86 ~amd64"
IUSE="opengl xscreensaver"
DEPEND="$(deprange $PV $MAXKDEVER kde-base/kscreensaver)
	opengl? ( virtual/opengl )
	!ppc64? ( xscreensaver? ( x11-misc/xscreensaver ) )"

PATCHES="${FILESDIR}/kdeartwork-3.4.0_beta2-gl-kdesavers.patch"

src_compile() {
	myconf="$myconf --with-dpms $(use_with opengl gl)"
	kde-meta_src_compile
}
