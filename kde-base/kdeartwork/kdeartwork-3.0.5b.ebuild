# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeartwork/kdeartwork-3.0.5b.ebuild,v 1.2 2003/04/09 12:20:13 danarmak Exp $
inherit kde-dist eutils

IUSE="opengl"
DESCRIPTION="KDE $PV - artwork"
KEYWORDS="x86 ~ppc ~alpha sparc"

newdepend "opengl? ( virtual/opengl ) ~kde-base/kdebase-${PV}"

myconf="$myconf --with-dpms"
use opengl && myconf="$myconf --with-gl" || myconf="$myconf --without-gl" 

src_unpack() {
	kde_src_unpack
	cd ${S}
	# added to fix GL problems within xscreensavers
	epatch ${FILESDIR}/kdeartwork-screensaver.patch
}

# kepp this here just in case, seems fixed though
src_install() {
	dodir ${PREFIX}/share/apps/kthememgr/Themes
	kde_src_install all
}
