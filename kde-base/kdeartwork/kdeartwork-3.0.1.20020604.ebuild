# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeartwork/kdeartwork-3.0.1.20020604.ebuild,v 1.3 2002/07/11 06:30:26 drobbins Exp $

inherit kde-patch kde-dist 

newdepend "opengl? ( virtual/opengl ) >=kde-base/kdebase-${PV}"

DESCRIPTION="${DESCRIPTION}Artwork"

myconf="$myconf --with-dpms"
use opengl && myconf="$myconf --with-gl" || myconf="$myconf --without-gl" 

src_unpack() {

    base_src_unpack

    cd ${S}
    # added to fix GL problems within xscreensavers
    patch -p1 < ${FILESDIR}/kdeartwork-screensaver.patch

}

src_install() {
	dodir ${KDEDIR}/share/apps/kthememgr/Themes
	kde_src_install all
}
