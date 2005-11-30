# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/vtwm/vtwm-5.4.6a.ebuild,v 1.1 2003/08/24 19:04:40 usata Exp $

IUSE=""

DESCRIPTION="VTWM, one of many TWM descendants and implements a Virtual Desktop. VTWM is lightweight and fast, feature-rich and versatile, mature, and yes, it can look nice, too"
HOMEPAGE="http://www.visi.com/~hawkeyd/vtwm.html"
SRC_URI="ftp://ftp.visi.com/users/hawkeyd/X/${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
DEPEND="virtual/x11"
	
S="${WORKDIR}/${P}"

src_compile() {
	xmkmf || die
	make || die 
}

src_install() {
	cp ${FILESDIR}/vtwmrc system.vtwmrc	
	make BINDIR=/usr/bin \
		LIBDIR=/etc/X11 \
		MANPATH=/usr/share/man \
		DESTDIR=${D} install || die

	echo "#!/bin/sh" > vtwm
	echo "xsetroot -cursor_name left_ptr &" >> vtwm
	echo "/usr/X11R6/bin/vtwm" >> vtwm
	exeinto /etc/X11/Sessions
	doexe vtwm
	dodoc doc/4.6.*
	dodoc doc/CHANGELOG
	dodoc doc/BUGS
	dodoc doc/DEVELOPERS
	dodoc doc/HISTORY
	dodoc doc/SOUND
	dodoc doc/WISHLIST
}
