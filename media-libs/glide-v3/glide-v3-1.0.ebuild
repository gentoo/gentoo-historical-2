# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Peter Gavin <your email>
# $Header: /var/cvsroot/gentoo-x86/media-libs/glide-v3/glide-v3-1.0.ebuild,v 1.5 2002/01/28 19:34:23 azarah Exp $

S=${WORKDIR}/glide3
DESCRIPTION="the glide library (for voodoo3 cards)"
SRC_URI="http://www.ibiblio.org/gentoo/glide-3.20010821.tar.bz2"
HOMEPAGE="http://dri.sourceforge.net/"
DEPEND=""
RDEPEND=""

src_install () {
	insinto /usr/include/glide3
	doins ${S}/*.h
	into /usr/X11R6
	newlib.so ${S}/libglide3.so-voodoo3 libglide3.so
}

