# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Bruce A. Locke <blocke@shivan.org>
# $Header: /var/cvsroot/gentoo-x86/media-sound/grip/grip-2.98.2.ebuild,v 1.1 2002/01/20 11:23:22 azarah Exp $

S=${WORKDIR}/${P}
DESCRIPTION="GTK+ based Audio CD Ripper"
SRC_URI="http://www.nostatic.org/grip/${P}.tar.gz"
HOMEPAGE="http://www.nostatic.org/grip"

DEPEND=">=x11-libs/gtk+-1.2.10
	media-sound/cdparanoia
	media-libs/id3lib
	virtual/x11"

RDEPEND="$DEPEND
	media-sound/lame"

src_compile() {
	local myconf=""
	if [ -z "`use nls`" ] ; then
		myconf="--disable-nls"
	fi

	# apply CFLAGS
	mv Makefile.in Makefile.in.old
	sed -e "s/CFLAGS = -g -O2/CFLAGS = ${CFLAGS}/" \
		Makefile.in.old > Makefile.in

	# fix cdparanoia libs not linking
	mv src/Makefile.in src/Makefile.in.orig
	sed -e "s/LDFLAGS =/LDFLAGS = -lcdda_interface -lcdda_paranoia/" \
		src/Makefile.in.orig > src/Makefile.in

	./configure --prefix=/usr \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--sysconfdir=/etc \
		${myconf} || die

	emake || die
}

src_install () {
	make prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		sysconfdir=${D}/etc \
		install || die

	dodoc ABOUT-NLS AUTHORS CREDITS LICENSE CHANGES README TODO
}
