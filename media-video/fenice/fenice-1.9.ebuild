# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/fenice/fenice-1.9.ebuild,v 1.3 2005/04/13 09:53:48 lu_zero Exp $

DESCRIPTION="Experimental rtsp streaming server"
HOMEPAGE="http://streaming.polito.it/server"
SRC_URI="http://streaming.polito.it/files/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""

DEPEND="sys-libs/glibc
		app-text/ghostscript"

RDEPEND="sys-libs/glibc"
src_unpack() {
	unpack ${A}
	sed -i -e "s:PACKAGE_NAME/avroot:PACKAGE_NAME/avroot/:g" ${S}/configure
}
src_compile() {
	econf --disable-fhs23 || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
}
