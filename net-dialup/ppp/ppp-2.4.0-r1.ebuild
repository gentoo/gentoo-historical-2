# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-dialup/ppp/ppp-2.4.0-r1.ebuild,v 1.2 2000/08/16 04:38:13 drobbins Exp $

P="ppp-2.4.0"      
A="${P}.tar.gz"
S=${WORKDIR}/${P}
DESCRIPTION="Point-to-point protocol - used for communicating with your ISP"
SRC_URI="ftp://ftp.linuxcare.com.au/pub/ppp/${A}"
src_unpack() {

 unpack ppp-2.4.0.tar.gz 
 cd ${S}

}

src_compile() {   
    cd ${S}                       
    ./configure --prefix=/usr
    #fix Makefiles to compile optimized
    cd ${S}
    cd pppd
    mv Makefile Makefile.orig
    sed -e "s:COPTS = -O2 -pipe -Wall -g:COPTS = ${CFLAGS}:" -e "s/LIBS =/LIBS = -lcrypt/" Makefile.orig > Makefile
    cd ../pppstats
    mv Makefile Makefile.orig
    sed -e "s:COPTS = -O:COPTS = ${CFLAGS}:" Makefile.orig > Makefile
    cd ../chat
    mv Makefile Makefile.orig
    sed -e "s:-O2:${CFLAGS}:" Makefile.orig > Makefile
    cd ../pppdump
    mv Makefile Makefile.orig
    sed -e "s:CFLAGS= -O:CFLAGS= ${CFLAGS}:" Makefile.orig > Makefile
    cd ..
    export CC=gcc
    make
}

src_install() {                               
	into /usr
	for y in chat pppd pppdump pppstats
	do
	    doman ${y}/${y}.8
	    dosbin ${y}/${y}
	done
	chmod u+s-w ${D}/usr/sbin/pppd
	chown root:daemon ${D}/usr/sbin/pppstats
	dodir /etc/ppp
	insinto /etc/ppp
	insopts -m0600
	doins etc.ppp/pap-secrets etc.ppp/chap-secrets
	insopts -m0644
	doins etc.ppp/options
	dodoc PLUGINS README* SETUP Changes-2.3 FAQ
}


