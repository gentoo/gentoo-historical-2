# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-editors/nedit/nedit-5.1.1-r2.ebuild,v 1.2 2001/11/10 02:54:28 hallski Exp $

S=${WORKDIR}/${P}
DESCRIPTION="NEdit is a multi-purpose text editor for the X Window System"
SRC_URI="ftp://ftp.nedit.org/pub/v5_1_1/${P}-src.tar.gz"
HOMEPAGE="http://nedit.org/"

DEPEND="virtual/glibc
	>=dev-util/yacc-1.9.1
	>=x11-libs/openmotif-2.1.30"

RDEPEND="virtual/glibc
	>=x11-libs/openmotif-2.1.30"
	
src_unpack() {

  unpack ${A}
  cd ${S}/makefiles
  cp Makefile.linux Makefile.orig
  sed -e "s:-O:${CFLAGS}:" Makefile.orig > Makefile.linux

}

src_compile() {

    try make linux

}

src_install () {

    into /usr
    dobin source/nc source/nedit
    newman nedit.man nedit.1
    newman nc.man nc.1
    dodoc README ReleaseNotes nedit.doc

}

