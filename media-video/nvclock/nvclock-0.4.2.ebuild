# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Daniel Robbins <drobbins@gentoo.org> 
# $Header: /var/cvsroot/gentoo-x86/media-video/nvclock/nvclock-0.4.2.ebuild,v 1.2 2002/01/14 05:56:14 drobbins Exp $

S=${WORKDIR}/${PN}${PV}
SRC_URI="http://www.evil3d.net/download/${PN}/${PN}${PV}.tar.gz"
DESCRIPTION="NVIDIA overclocking utility"
HOMEPAGE="http://www.evil3d.net/products/nvclock/"

RDEPEND="virtual/glibc gtk? ( virtual/x11 >=x11-libs/gtk+-1.2.10-r4 )"
DEPEND="$RDEPEND sys-devel/autoconf"

src_compile() {
	local myconf
	use gtk && myconf="--enable-gtk"
	autoconf
	touch config.h.in
	./configure --host=${CHOST} --prefix=/usr --mandir=/usr/share/man ${myconf} || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install	
	dodoc AUTHORS COPYING README	
}

