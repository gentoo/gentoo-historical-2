# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/DFBSee/DFBSee-0.7.2.ebuild,v 1.6 2003/02/13 13:22:25 vapier Exp $
 
S=${WORKDIR}/${P}
DESCRIPTION="DFBSee is image viewer and video player based on DirectFB"
SRC_URI="http://www.directfb.org/download/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.directfb.org/dfbsee.xml"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND="virtual/x11 dev-libs/DirectFB"

src_install () {
	
	make DESTDIR=${D} install || die
	
}
