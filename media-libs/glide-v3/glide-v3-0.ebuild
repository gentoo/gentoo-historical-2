# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Peter Gavin <your email>
# $Header: /var/cvsroot/gentoo-x86/media-libs/glide-v3/glide-v3-0.ebuild,v 1.1 2001/08/04 18:22:45 pete Exp $

S=${WORKDIR}/${P}
DESCRIPTION="the glide library (for voodoo3 cards)"
SRC_URI="http://dri.sourceforge.net/res/glide3headers.tar.gz
         http://dri.sourceforge.net/res/voodoo3/x86/libglide3.so"
HOMEPAGE="http://dri.sourceforge.net/"
DEPEND=""
RDEPEND=""

src_unpack() {
	mkdir ${S}
	cd ${S}
	unpack glide3headers.tar.gz
	chown -R 0.0 glide
}

src_compile() {

}

src_install () {
	dodir /usr/include
	cp -a ${S}/glide /usr/include
	cp -a ${DISTDIR}/libglide.so /usr/lib
}

