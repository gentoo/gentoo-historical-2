# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Chris Arndt <arndtc@mailandnews.com>
# $Header: /var/cvsroot/gentoo-x86/media-sound/glame/glame-0.5.3.ebuild,v 1.1 2002/01/19 13:50:00 verwilst Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Glame is an audio file editing utility."
SRC_URI="http://download.sourceforge.net/glame/${P}.tar.gz"
HOMEPAGE="http://glame.sourceforge.net/glame/"

DEPEND="virtual/glibc
	>=dev-util/guile-1.4-r3
	>=dev-util/glade-0.6.2
        >=dev-libs/libxml-1.8.16
        >=media-libs/audiofile-0.2.1"

src_compile() {

	./configure --infodir=/usr/share/info --mandir=/usr/share/man --prefix=/usr --host=${CHOST} || die
	emake || die

}


src_install () {

	make DESTDIR=${D} install || die
	dodoc AUTHORS BUGS COPYING CREDITS Changelog INSTALL MAINTAINERS NEWS README TODO

}
