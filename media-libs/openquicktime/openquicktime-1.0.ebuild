# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author: Ryan Phillips <rphillips@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-libs/openquicktime/openquicktime-1.0.ebuild,v 1.1 2002/04/25 08:40:36 rphillips Exp $

S=${WORKDIR}/${P}
DESCRIPTION="OpenQuicktime library for linux"
SRC_URI="http://prdownloads.sourceforge.net/openquicktime/${P}-src.tgz"
HOMEPAGE="http://openquicktime.sourceforge.net/"

DEPEND="media-sound/lame
        media-sound/mpg123
		media-libs/jpeg"

src_compile() {
	cd ${S}-src
	
	./configure \
		--enable-debug=no \        # Disable debug - enabled by default
		--prefix=/usr || die   	
		
	make || die
}

src_install() {
	cd ${S}-src
	dolib.so libopenquicktime.so
	dodoc README AUTHORS NEWS COPYING TODO
	make \
		prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		docdir=${D}/usr/share/doc/${PF}/html \
		sysconfdir=${D}/etc \
		install || die
}
