# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-libs/smpeg/smpeg-0.4.4-r2.ebuild,v 1.1 2002/02/02 23:09:30 azarah Exp $

S=${WORKDIR}/${P}
DESCRIPTION="SDL MPEG Player Library"
SRC_URI="ftp://ftp.lokigames.com/pub/open-source/smpeg/${P}.tar.gz"
HOMEPAGE="http://www.lokigames.com/development/smpeg.php3"

DEPEND=">=media-libs/libsdl-1.2.0
	opengl? ( virtual/opengl virtual/glu )
	gtk? ( >=x11-libs/gtk+-1.2.10-r4 )"

src_compile() {

	local myconf
# --enable-mmx causes test apps to crash on startup .. smpeg bug?
# bugzilla bug #470 -- azarah (03/02/2002)
#	if [ "`use mmx`" ] ; then
#		myconf="--enable-mmx"
#	fi
	if [ -z "`use gtk`" ] ; then
		myconf="${myconf} --disable-gtk-player"
	fi
	if [ -z "`use X`" ] ; then
		myconf="${myconf} --disable-gtk-player --without-x"
	fi
	if [ -z "`use opengl`" ] ; then
		myconf="${myconf} --disable-opengl-player"
	fi
	
	./configure --prefix=/usr \
		--mandir=/usr/share/man \
		--host=${CHOST} \
		${myconf} || die
		
	emake || die
}

src_install () {

	make DESTDIR=${D} install || die

	dodoc CHANGES COPYING README* TODO
}

