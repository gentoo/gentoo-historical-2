# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/nxclient/nxclient-1.4.0.ebuild,v 1.5 2004/10/03 21:47:56 swegener Exp $

inherit rpm

DESCRIPTION="NXClient is a X11/VNC/NXServer client especially tuned for using remote desktops over low-bandwidth links such as the Internet"
HOMEPAGE="http://www.nomachine.com"

IUSE=""
LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 -ppc -sparc -alpha -mips"
RESTRICT="nostrip"

MY_PV="${PV}-49"
SRC_URI="http://www.nomachine.com/download/snapshot/nxbinaries/Linux/${PN}-${MY_PV}.i386.rpm"

DEPEND=">=media-libs/jpeg-6b-r3
	>=sys-libs/glibc-2.3.2-r1
	>=sys-libs/zlib-1.1.4-r1
	virtual/x11
	>=dev-libs/expat-1.95.6-r1
	>=media-libs/fontconfig-2.2.0-r2
	>=media-libs/freetype-2.1.4
	>=media-libs/jpeg-6b-r3
	>=x11-libs/qt-3.3.2
	net-misc/nx-x11"

S="${WORKDIR}"

src_compile() {
	return;
}

src_install() {
	exeinto /usr/NX/bin
#	doexe usr/NX/bin/nxartsdstatus
	doexe usr/NX/bin/nxclient
	doexe usr/NX/bin/nxproxy
#	doexe usr/NX/bin/nxssh

#	insinto /usr/NX/lib
#	dolib usr/NX/lib/libXcomp.so.1.2.2

	insinto /usr/NX/share
	doins usr/NX/share/client.id_dsa.key
	doins usr/NX/share/keyboards
	insinto /usr/NX/share/icons
	doins usr/NX/share/icons/*
	insinto /usr/NX/share/images
	doins usr/NX/share/images/*.png

	insinto /etc/env.d
	doins ${FILESDIR}/1.3.0/50nxclient

	for x in `echo /usr/kde/*` ; do
		insinto $x/share/applnk/Internet
		doins "usr/NX/share/applnk/NX Client for Linux/nxclient-admin.desktop"
		doins "usr/NX/share/applnk/NX Client for Linux/nxclient-help.desktop"
		doins "usr/NX/share/applnk/NX Client for Linux/nxclient-wizard.desktop"
		doins "usr/NX/share/applnk/NX Client for Linux/nxclient.desktop"
	done
}
