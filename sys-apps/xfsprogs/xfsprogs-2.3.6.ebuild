# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/xfsprogs/xfsprogs-2.3.6.ebuild,v 1.2 2002/12/29 00:19:28 drobbins Exp $

DESCRIPTION="xfs filesystem utilities"

SRC_URI="ftp://oss.sgi.com/projects/xfs/download/cmd_tars/${P}.src.tar.gz"
HOMEPAGE="http://oss.sgi.com/projects/xfs"

KEYWORDS="x86"
SLOT="0"
LICENSE="LGPL-2.1"

S=${WORKDIR}/${P}

DEPEND="sys-apps/e2fsprogs"

src_compile() {
	CFLAGS="`echo ${CFLAGS} | sed "s/ -O[2-9]/ -O1/g"`"
	CXXFLAGS="`echo ${CXXFLAGS} | sed "s/ -O[2-9]/ -O1/g"`"
	
	OPTIMIZER="${CFLAGS}"
	DEBUG=-DNDEBUG
	
	autoconf || die
	
	./configure --prefix=/usr \
			--bindir=/bin \
			--sbindir=/sbin \
			--libdir=/lib \
		    --libexecdir=/lib \
		    --mandir=/usr/share/man || die "config failed"
		    
	cp include/builddefs include/builddefs.orig
	sed -e "s:/usr/share/doc/${PN}:/usr/share/doc/${PF}:" \
	-e 's:-O1::' \
	-e '/-S $(PKG/d' \
	-e 's:^PKG_\(.*\)_DIR = \(.*\)$:PKG_\1_DIR = ${DESTDIR}\2:' \
	include/builddefs.orig > include/builddefs || die "sed failed"
	
	make || die
}

src_install() {
	make DESTDIR=${D} DK_INC_DIR=${D}/usr/include/disk install install-dev || die "make install failed"
	
	cat ${S}/libhandle/.libs/libhandle.la | sed -e 's:installed=no:installed=yes:g' > ${D}/lib/libhandle.la
	
	dosym /lib/libhandle.so.1 /lib/libhandle.so	
}
