# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/x11-terms/eterm/eterm-0.9.1-r3.ebuild,v 1.1 2002/03/27 22:58:22 seemant Exp $

P0N=Eterm
S=${WORKDIR}/${P0N}-${PV}
DESCRIPTION="A vt102 terminal emulator for X"
SRC_URI="http://www.eterm.org/download/${P0N}-${PV}.tar.gz
		 http://www.eterm.org/download/${P0N}-bg-${PV}.tar.gz
		 http://www.eterm.org/themes/0.9.1/glass-Eterm-theme.tar.gz"
HOMEPAGE="http://eterm,sourceforge.net"

DEPEND="virtual/glibc
		virtual/x11
		>=x11-libs/libast-0.4-r1
		>=media-libs/imlib2-1.0.4-r1"

src_unpack() {
	unpack ${P0N}-${PV}.tar.gz
	cd ${S}
	unpack ${P0N}-bg-${PV}.tar.gz
}

src_compile() {

    cd ${S}
	# always disable mmx because binutils 2.11.92+ seems to be broken for this package
    ./configure \
		--disable-mmx	\
		--prefix=/usr	\
		--mandir=/usr/share/man	\
		--host=${CHOST} \
		--with-imlib || die
		
    emake || die

}

src_install () {

    cd ${S}
	dodir /usr/share/terminfo
    make 	\
		DESTDIR=${D}	\
		TIC="tic -o ${D}/usr/share/terminfo"	\
		install || die

    dodoc COPYING ChangeLog README ReleaseNotes
    dodoc bg/README.backgrounds
	cd ${D}/usr/share/Eterm/themes
	unpack glass-Eterm-theme.tar.gz
}
