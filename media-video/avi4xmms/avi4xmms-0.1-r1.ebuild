# Copyright 2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author: Seemant Kulleen <seemant@gentoo.org> 
# $Header: /var/cvsroot/gentoo-x86/media-video/avi4xmms/avi4xmms-0.1-r1.ebuild,v 1.1 2002/05/26 14:05:33 azarah Exp $

S=${WORKDIR}/${PN}
DESCRIPTION="A plugin for XMMS to play AVI/DivX/ASF movies"
SRC_URI="http://prdownloads.sourceforge.net/my-xmms-plugs/${P}.tar.gz"
HOMEPAGE="http://sourceforge.net/projects/my-xmms-plugs/"

DEPEND="virtual/glibc
	>=media-video/avifile-0.7.4.20020426-r2
	>=media-sound/xmms-1.2.7-r6"

src_unpack() {

	unpack ${A}

	cd ${S}
	patch -p1 < ${FILESDIR}/${P}-avif0.7.patch || die
}

src_compile() {

	libtoolize --copy --force

    ./configure \
		--prefix=/usr \
		--host=${CHOST} || die

    emake || die
}

src_install () {

    make \
		libdir=/usr/lib/xmms/Input \
		DESTDIR=${D} install || die

    dodoc AUTHORS COPYING ChangeLog README TODO
}

pkg_postinst() {
	
	einfo
	einfo "**************************************************************"
	einfo "  For avi4xmms to work, you need to remerge xmms with \"avi\""
	einfo "  in your USE flags if you havent at the time."
	einfo
	einfo "  # USE=\"avi\" emerge xmms"
	einfo
	einfo "**************************************************************"
	einfo
}

