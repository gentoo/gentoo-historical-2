# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/xine-dvdnav/xine-dvdnav-0.9.13.ebuild,v 1.2 2002/12/12 09:32:33 agenkin Exp $

S="${WORKDIR}/${P}"
DESCRIPTION="DVD Navigator plugin for Xine.  Also add CSS decription support."
HOMEPAGE="http://dvd.sourceforge.net/"
SRC_URI="mirror://sourceforge/dvd/${P}.tar.gz"

DEPEND=" >=media-libs/libdvdcss-0.0.3.3
	>=media-libs/libdvdread-0.9.2
	=media-libs/xine-lib-0.9.13
	=media-libs/libdvdnav-0.1.3*"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc"


src_compile () {

	econf || die
	emake || die
}

src_install() {
	
	einstall || die
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README TODO
}
