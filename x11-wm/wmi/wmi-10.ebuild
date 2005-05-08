# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/wmi/wmi-10.ebuild,v 1.6 2005/05/08 14:40:55 herbs Exp $

DESCRIPTION="WMI is a new window manager for X11, which combines the best features of larswm, ion, evilwm and ratpoison into one window manager."
SRC_URI="http://download.berlios.de/wmi/${P}.tar.gz"
HOMEPAGE="http://wmi.modprobe.de/"

LICENSE="as-is"
DEPEND="virtual/x11
	dev-libs/expat
	media-libs/fontconfig
	media-libs/freetype"

KEYWORDS="x86 ppc ~ppc-macos amd64"
SLOT="0"
IUSE=""

src_compile() {
	econf --with-slot-support --with-xft-support || die
	emake || die
}

src_install () {
	make install DESTDIR=${D} || die

	dodoc AUTHORS BUGS CONTRIB COPYING ChangeLog FAQ INSTALL LICENSE.txt \
		  NEWS README TODO

	docinto examples
	dodoc examples/*.sh

	docinto examples/themes
	dodoc examples/themes/*

	echo -e "#!/bin/sh\n/usr/bin/wmi" > ${T}/wmi
	exeinto /etc/X11/Sessions
	doexe ${T}/wmi

	insinto /usr/share/xsessions
	doins ${FILESDIR}/wmi.desktop
}
