# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# Maintainer: System Team <system@gentoo.org>
# Author: Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-libs/db/db-3.2.3h-r4.ebuild,v 1.5 2002/02/10 17:49:53 gbevin Exp $

S=${WORKDIR}/${P}/build_unix
DESCRIPTION="Berkeley DB for transaction support in MySQL"
SRC_URI="ftp://mysql.valueclick.com/mysql/Downloads/db/${P}.tar.gz http://download.sourceforge.net/pub/mirrors/mysql/Downloads/db/${P}.tar.gz"
HOMEPAGE="http://www.mysql.com"
SLOT="2"
RDEPEND="virtual/glibc"
DEPEND="$RDEPEND =sys-libs/db-1.85-r1"

src_compile() {
	../dist/configure --host=${CHOST} --enable-compat185 --enable-dump185 --prefix=/usr --enable-shared --enable-static --enable-cxx || die
	#--enable-rpc does not work
	echo
	# Parallel make does not work
	echo "Building static libs..."
	make libdb=libdb-3.2.a libdb-3.2.a || die
	make libcxx=libdb_cxx-3.2.a libdb_cxx-3.2.a || die
	echo
	echo "Building db_dump185..."
	/bin/sh ./libtool --mode=compile cc -c ${CFLAGS} -I/usr/include/db1 -I../dist/../include -D_REENTRANT ../dist/../db_dump185/db_dump185.c || die
	gcc -s -static -o db_dump185 db_dump185.lo -L/usr/lib -ldb1 || die
	echo
	echo "Building everything else..."
	make libdb=libdb-3.2.a libcxx=libdb_cxx-3.2.a || die
}

src_install () {
    make libdb=libdb-3.2.a libcxx=libcxx_3.2.a prefix=${D}/usr install || die
    dolib.a libdb-3.2.a libdb_cxx-3.2.a
    dolib libdb-3.2.la libdb_cxx-3.2.la

    dodir usr/include/db3
    cd ${D}/usr/include
    mv *.h db3
    ln db3/db.h db.h
	
    cd ${D}/usr/lib
    ln -s libdb-3.2.so libdb.so.3
    
    sed 's,installed=no,installed=yes,' < ${D}/usr/lib/libdb-3.2.la > ${D}/usr/lib/libdb-3.2.la.new
    mv ${D}/usr/lib/libdb-3.2.la.new ${D}/usr/lib/libdb-3.2.la
    sed 's,installed=no,installed=yes,' < ${D}/usr/lib/libdb_cxx-3.2.la > ${D}/usr/lib/libdb_cxx-3.2.la.new
    mv ${D}/usr/lib/libdb_cxx-3.2.la.new ${D}/usr/lib/libdb_cxx-3.2.la

    cd ${S}/..
    dodoc README LICENSE
    if [ -d ${D}/usr/share/doc/${PF} ]
    then
	mv ${D}/usr/docs ${D}/usr/share/doc/${PF}/html
    else
	mv ${D}/usr/docs ${D}/usr/doc/${PF}/html
    fi
    prepalldocs

	#for some reason, db.so's are *not* readable by group or others, resulting in no one
	#but root being able to use them!!! This fixes it -- DR 15 Jun 2001
	cd ${D}/usr/lib
	chmod go+rx *.so
	#.la's aren't go readable either
	chmod go+r *.la
	#ok, everything should be fixed now :)
}

