# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author: Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-libs/lcms/lcms-1.08.ebuild,v 1.1 2002/04/30 13:22:23 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A lightweight, speed optimized color management engine"
SRC_URI="http://www.littlecms.com/${P}.tar.gz"
HOMEPAGE="http://www.littlecms.com/index.htm"

DEPEND="tiff? ( media-libs/tiff )
	jpeg? ( media-libs/jpeg
		sys-libs/zlib )"

src_compile() {

	make || die

	( use tiff && use jpeg ) && make tifficc
}

src_install () {

	make \
		DESTDIR=${D} \
		install || die

	cd ${D}/usr/include
	cp lcms.h lcms.orig
	sed -e "s:#define VERSION.*::" \
		-e "s:#define PACKAGE.*::" \
		lcms.orig > lcms.h
	rm lcms.orig

	dodir /usr/include/lcms
	mv ${D}/usr/include/*.h ${D}/usr/include/lcms

	cd ${S}/testbed
	dodir /usr/share/lcms/profiles
	cp *.icm ${D}/usr/share/lcms/profiles
	cd ${S}

	dodoc AUTHORS COPYING ChangeLog README* INSTALL NEWS README
	docinto txt
	dodoc doc/*

}
