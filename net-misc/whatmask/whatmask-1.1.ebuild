# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Ben Lutgens <lamer@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-misc/whatmask/whatmask-1.1.ebuild,v 1.2 2002/07/09 11:37:27 phoenix Exp $

S=${WORKDIR}/${P}
DESCRIPTION="little C program to compute different subnet mask notations"
SRC_URI="http://downloads.laffeycomputer.com/current_builds/whatmask/${P}.tar.gz"
HOMEPAGE="http://www.laffeycomputer.com/whatmask.html"
DEPEND="virtual/glibc"
KEYWORDS="x86"
LICENSE="GPL-2"
SLOT="0"

#RDEPEND=""

src_compile() {
	try ./configure --infodir=/usr/share/info --mandir=/usr/share/man --prefix=/usr --host=${CHOST}
	
	emake || die
	#make || die
}

src_install () {
	
	# try make prefix=${D}/usr install

    try make DESTDIR=${D} install
	 dodoc README INSTALL AUTHORS ChangeLog NEWS
}

