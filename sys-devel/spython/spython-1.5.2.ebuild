# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-devel/spython/spython-1.5.2.ebuild,v 1.2 2000/12/24 14:00:14 achim Exp $

P=spython-1.5.2      
A="py152.tgz python-fchksum-1.1.tar.gz"
S=${WORKDIR}/Python-1.5.2
S2=${WORKDIR}/python-fchksum-1.1
DESCRIPTION="A really great language"
SRC_URI="http://www.python.org/ftp/python/src/py152.tgz 
	 http://www.azstarnet.com/~donut/programs/fchksum/python-fchksum-1.1.tar.gz"

HOMEPAGE="http://www.python.org
	  http://www.azstarnet.com/~donut/programs/fchksum/"
DEPEND=">=sys-libs/gdbm-1.8.0
	>=sys-libs/gpm-1.19.3"
RDEPEND="$DEPEND
	 >=sys-apps/bash-2.04"
PROVIDE="virtual/python-1.5.2"

src_compile() {   
    cd ${S}
    export LDFLAGS=-static
    try ./configure --prefix=/ 
    cp Makefile Makefile.orig
    sed -e "s/-g -O2/${CFLAGS}/" Makefile.orig > Makefile
    cd ${S}/Modules
    cp Makefile.pre Makefile.orig
    sed -e "s:MODOBJS=:MODOBJS=fchksum.o md5_2.o:" \
    Makefile.orig > Makefile.pre

    echo "fchksum.o: \$(srcdir)/fchksum.c; \$(CC) \$(CFLAGS) -c \$(srcdir)/fchksum.c" >> Makefile.pre
    echo "md5_2.o: \$(srcdir)/md5_2.c; \$(CC) \$(CFLAGS) -c \$(srcdir)/md5_2.c" >> Makefile.pre
    echo "fchksum\$(SO):  fchksum.o md5.o; \$(LDSHARED)  fchksum.o md5_2.o  -lz -o fchksum\$(SO)" >> Makefile.pre
    # Parallel make does not work
    cd ${S}
    try make 
}

src_unpack() {
    unpack py152.tgz
    cd ${S}/Modules
    sed -e 's/#readline/readline/' -e 's/-lreadline -ltermcap/-lreadline/' \
	-e 's/#_locale/_locale/' -e 's/#crypt/crypt/' -e 's/# -lcrypt/-lcrypt/' \
	-e 's/#syslog/syslog/' -e 's/#curses cursesmodule.c -lcurses -ltermcap/curses cursesmodule.c -lncurses/' \
	-e 's:#gdbm gdbmmodule.c -I/usr/local/include -L/usr/local/lib -lgdbm:gdbm gdbmmodule.c -lgdbm:' \
	-e 's:#zlib zlibmodule.c -I$(prefix)/include -L$(exec_prefix)/lib -lz:zlib zlibmodule.c -lz:' \
	-e 's:#dbm.*:dbm dbmmodule.c -I/usr/include/db1 -lndbm:' \
	-e 's:#\*shared\*:\*static\*:' \
	-e 's:^TKPATH=\:lib-tk:#TKPATH:' \
	Setup.in > Setup

   cp ${FILESDIR}/pfconfig.h .
   unpack python-fchksum-1.1.tar.gz 

   cd python-fchksum-1.1
   mv md5.h ../md5_2.h
   sed -e 's:"md5.h":"md5_2.h":' md5.c > ../md5_2.c
   sed -e 's:"md5.h":"md5_2.h":' fchksum.c > ../fchksum.c
}


src_install() {                 
                
    try make install prefix=${D}
    mv ${D}/bin/python ${D}/bin/spython
    mv ${D}/bin/python1.5 ${D}/bin/spython1.5
   # for i in lib-dynload lib-stdwin lib-tk test
   # do
   #     rm -r ${D}/lib/python1.5/${i}
   # done
   # rm -r ${D}/include 
    rm -r ${D}/man
    dodoc README
}

