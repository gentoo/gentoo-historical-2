# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/x11-wm/enlightenment/enlightenment-0.16.5-r2.ebuild,v 1.1 2001/10/08 22:49:41 azarah Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Enlightenment Window Manager"
SRC_URI="ftp://ftp.enlightenment.org/enlightenment/enlightenment/${P}.tar.gz"
HOMEPAGE="http://www.enlightenment.org/"

DEPEND=">=media-libs/fnlib-0.5
	>=media-sound/esound-0.2.19
	~media-libs/freetype-1.3.1-r3
	>=gnome-base/libghttp-1.0.9-r1"


src_compile() {
  
	./configure --host=${CHOST} 				\
		    --enable-fsstd				\
		    --prefix=/usr				\
		    --mandir=/usr/share/man			\
		    --infodir=/usr/share/info || die
	emake || die
}

src_install() {

	make prefix=${D}/usr 				\
		localedir=${D}/usr/share/locale		\
		gnulocaledir=${D}/usr/share/locale	\
		install || die
  
	doman man/enlightenment.1
	dodoc ABOUT-NLS AUTHORS ChangeLog COPYING FAQ INSTALL NEWS README
	docinto sample-scripts
	dodoc sample-scripts/*
}



