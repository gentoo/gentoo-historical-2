# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author: Michael Nazaroff <naz@gentoo.org>
# $Header: /home/cvsroot/gentoo-x86/media-video/DFBSee/DFBSee-0.7.2ebuild
 
S=${WORKDIR}/${P}
DESCRIPTION="DFBSee is image viewer and video player based on DirectFB"
SRC_URI="http://www.directfb.org/download/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.directfb.org/dfbsee.xml"
LICENSE="GPL-2"

DEPEND="virtual/x11 dev-libs/DirectFB"
	
RDEPEND="${DEPEND}"

src_install () {
	
	make DESTDIR=${D} install || die
	
}
