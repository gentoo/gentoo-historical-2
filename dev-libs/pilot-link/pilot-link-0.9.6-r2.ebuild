# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# AJ Lewis <aj@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-libs/pilot-link/pilot-link-0.9.6-r2.ebuild,v 1.1 2001/12/06 07:06:17 hallski Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A suite of tools contains a series of conduits for moving
information to and from your Palm device and your desktop or workstation
system."

SRC_URI="http://www.gnu-designs.com/pilot-link/source/${P}.tar.gz
	 http://www.eskil.org/gnome-pilot/download/tarballs/${P}.tar.gz"
HOMEPAGE="http://www.gnu-designs.com/pilot-link/"
DEPEND="virtual/glibc"

src_compile() {
	./configure --host=${CHOST}					\
		    --prefix=/usr/					\
		    --mandir=/usr/share/man 				\
		    --infodir=/usr/share/info				\
		    --includedir=/usr/include/libpisock			\
		    --with-tcl=no					\
		    --with-itcl=no 					\
		    --with-tk=no					\
		    --with-python=no					\
		    --with-java=no					\
		    --with-perl5=no
	assert

	# The configure-script seems to be someone broken, 
	# It says that it finds iconv in our glibc but it doesn't 
	# set the #define correctly, I'll notify one of the pilot-link 
	# hackers. // Hallski

	cd ${S}/include
	echo "#define HAVE_ICONV 1" >> pi-config.h

	cd ${S}
	emake || die
}

src_install() {
	make prefix=${D}/usr						\
	     mandir=${D}/usr/share/man					\
	     includedir=${D}/usr/include/libpisock			\
	     infodir=${D}/usr/share/info				\
	     install || die

	dodoc COPYING COPYING.LIB ChangeLog README TODO 
	docinto sgml
	dodoc doc/syncabs.sgml
}
