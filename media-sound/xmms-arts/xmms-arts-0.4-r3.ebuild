# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-sound/xmms-arts/xmms-arts-0.4-r3.ebuild,v 1.2 2002/05/21 18:14:10 danarmak Exp $

inherit kde-base || die

# Note: we set many vars e.g. DEPEND insteaed of extending them because this isn't a proper KDE app,
# it only links against arts. So we need set-kdedir, but almost nothing else. So make sure it continues
# to override e.g. src_install.

DESCRIPTION="This output plugin allows xmms to work with arts, KDE's sound system"
SRC_URI="http://stukach.com/hosted/m.i.a/xmmsarts/xmmsarts-0.4.tar.gz"
# HOMEPAGE="http://home.earthlink.net/~bheath/xmms-arts/" #disappeared from the 'net?

newdepend "virtual/glibc
	sys-devel/gcc
	 >=media-sound/xmms-1.2.5-r1"

need-kde 3
	 
src_unpack() {
	unpack ${A}
	cd ${S}
	cp Makefile.am Makefile.orig
	sed -e "s:artsc-config:${KDE3DIR}/bin/artsc-config:" Makefile.orig > Makefile.am
	autoconf
}

src_compile() {     
	kde_src_compile myconf # calls set-kdedir
	CFLAGS="$CFLAGS -I/usr/X11R6/include -I/usr/include -I${KDE3DIR}/include -I${KDE3DIR}/include/artsc"  
	./configure --prefix=/usr --host=${CHOST} || die
	emake || die
}

src_install() {                               
	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING NEWS README
}

