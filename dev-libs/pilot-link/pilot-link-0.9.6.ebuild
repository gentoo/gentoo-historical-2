# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# AJ Lewis <aj@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-libs/pilot-link/pilot-link-0.9.6.ebuild,v 1.1 2001/10/08 09:09:10 hallski Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A suite of tools contains a series of conduits for moving
information to and from your Palm device and your desktop or workstation
system."

SRC_URI="http://www.gnu-designs.com/pilot-link/source/${P}.tar.gz
	 http://www.eskil.org/gnome-pilot/download/tarballs/${P}.tar.gz"
HOMEPAGE="http://www.gnu-designs.com/pilot-link/"
DEPEND="virtual/glibc"

src_compile() {
   try ./configure --prefix=/usr/ --mandir=/usr/share/man \
       --infodir=/usr/share/info  --with-tcl=no --with-itcl=no \
		--with-tk=no --with-python=no --with-java=no --with-perl5=no
	try make clean
   try make ${MAKEOPTS}
}

src_install() {
   try make prefix=${D}/usr/ mandir=${D}/usr/share/man infodir=${D}/usr/share/info install
   dodoc COPYING COPYING.LIB ChangeLog README TODO doc/syncabs.sgml
}

