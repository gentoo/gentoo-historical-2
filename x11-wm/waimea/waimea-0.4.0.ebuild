# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/waimea/waimea-0.4.0.ebuild,v 1.1 2002/11/06 21:10:19 bcowan Exp $
 
S=${WORKDIR}/${P}

DESCRIPTION="Window manager based on BlackBox"

SRC_URI="http://www.waimea.org/files/stable/source/${P}.tar.bz2"
HOMEPAGE="http://www.waimea.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

DEPEND="virtual/x11 
	media-libs/imlib2"
	
PROVIDE="virtual/blackbox"

src_compile() {
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--enable-shape \
		--enable-xinerama \
		--enable-render \
		--enable-randr \
		--enable-xft \
		--enable-pixmap
	emake || die
}

src_install() {
	einstall \
		sysconfdir=${D}/etc/X11/waimea \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		datadir=${D}/usr/share 
	
	dodoc ChangeLog AUTHORS COPYING INSTALL README TODO NEWS

	dodir /etc/X11/Sessions
	echo "/usr/bin/waimea" > ${D}/etc/X11/Sessions/waimea
	chmod +x ${D}/etc/X11/Sessions/waimea
}

pkg_postinst() {
	einfo "Please read the README in /usr/share/doc/${P}"
	einfo "for info on setting up and configuring waimea"
}
