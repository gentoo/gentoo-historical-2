# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/fenice/fenice-1.6.ebuild,v 1.1.1.1 2005/11/30 09:57:51 chriswhite Exp $

DESCRIPTION="Experimental rtsp streaming server"
HOMEPAGE="http://streaming.polito.it/fenice.shtml"
SRC_URI="http://streaming.polito.it/files/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""

DEPEND="sys-libs/glibc"

src_install() {
	make DESTDIR=${D} install || die "make install failed"
}
