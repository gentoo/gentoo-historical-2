# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/app-misc/xplore/xplore-1.1-r1.ebuild,v 1.2 2002/07/11 06:30:17 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="motif file manager for X."
SRC_URI="http://www.musikwissenschaft.uni-mainz.de/~ag/xplore/${P}.tar.bz2"
HOMEPAGE="http://www.musikwissenschaft.uni-mainz.de/~ag/xplore/"
DEPEND="virtual/x11
		>=x11-libs/openmotif-2.1.30-r1"

#RDEPEND=""

src_compile() {

	#Fix Xplore.tmpl so installation is to /usr instead of /usr/X11R6
	#Note: LIBDIR is used to point to X11 tree.
	cp Xplore.tmpl Xplore.tmpl.orig
	sed -e "s:^\(XPLORELIBDIR = \).*:\1/usr/lib/xplore:" \
		-e "s:^XCOMM \(BINDIR = /usr\)/local\(/bin\):\1\2:" \
		-e "s:^XCOMM \(MANPATH = /usr\)/local\(/man\):\1/share\2:" \
		Xplore.tmpl.orig > Xplore.tmpl
		
	xmkmf -a || die "xmkmf Makefile creation failed"
	emake || die "Parallel make failed."
	
}

src_install () {
	
	# try make prefix=${D}/usr install

    make DESTDIR=${D} install || die "Installation failed"
	 dodoc COPYING ChangeLog INSTALL README TODO
}

