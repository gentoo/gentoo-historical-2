# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/groff/groff-1.16.1.ebuild,v 1.6 2001/01/31 20:49:07 achim Exp $

P=groff-1.16.1
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Text formatter used for man pages"
SRC_URI="ftp://gatekeeper.dec.com/pub/GNU/groff/${A}
	 ftp://prep.ai.mit.edu/gnu/groff/${A}"
HOMEPAGE="http://www.gnu.org/software/groff/groff.html"

DEPEND="virtual/glibc
	>=sys-devel/gcc-2.95.2"

RDEPEND="$DEPEND
	 sys-devel/perl
	 sys-apps/bash"


src_compile() {
	try ./configure --host=${CHOST} --prefix=/usr
	cd ${S}/tmac
#	mv Makefile.sub Makefile.sub.orig
#	sed -e "s/all: stamp-strip stamp-wrap/all: stamp-strip/" Makefile.sub.orig > Makefile.sub
	#fixed some things with the build process using good 'ol sed
	cd ${S}
	# pmake does not work !
	try make 
}

src_install() {                               
	into /usr
	dodoc NEWS PROBLEMS PROJECTS README TODO VERSION \
	      BUG-REPORT COPYING ChangeLog FDL MORE.STUFF \
	      REVISION
        try make prefix=${D}/usr install 

}


