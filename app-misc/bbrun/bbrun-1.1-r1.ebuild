# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Craig Joly <joly@ee.ualberta.ca>
# $Header: /var/cvsroot/gentoo-x86/app-misc/bbrun/bbrun-1.1-r1.ebuild,v 1.4 2001/08/15 19:25:27 lordjoe Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="blackbox program execution dialog box"
SRC_URI="http://bbtools.thelinuxcommunity.org/sources/contrib/${A}"
HOMEPAGE="http://bbtools.thelinuxcommunity.org/contrib.phtml"

DEPEND=">=x11-wm/blackbox-0.61 
	>=x11-libs/gtk+-1.2.10"

src_unpack() {
	unpack ${A}
	cd ${S}/bbrun
	mv Makefile Makefile.orig
	try sed '/CFLAGS =/ s:$: -I/usr/X11R6/include/gtk-1.2 -I/usr/include/glib-1.2 '"${CFLAGS}"':' Makefile.orig > Makefile
}

src_compile() {
	cd ${S}/bbrun
	try emake
}

src_install () {

	dodoc README COPYING
	into /usr/X11R6
	dobin bbrun/bbrun
	cd /usr/X11R6/bin/wm
	cp blackbox blackbox.bak
	sed -e s:.*blackbox:"exec /usr/X11R6/bin/bbrun \&\n&": blackbox.bak > blackbox
}

