# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-misc/bind/bind-8.2.2-P5-r1.ebuild,v 1.1 2000/08/09 22:58:28 achim Exp $

P=bind-8.2.2-P5
A=bind-src.tar.gz
S=${WORKDIR}/src
CATEGORY="net-misc"
DESCRIPTION="Name Server"
SRC_URI="ftp://ftp.isc.org/isc/bind/src/8.2.2-P5/"${A}
HOMEPAGE="http://www.isc.org/products/BIND"

src_compile() {                           
    make clean
    make depend
    make all
}

src_unpack() {

    unpack ${A}
    cd ${S}/port/linux
    cp Makefile.set Makefile.set.orig
    sed -e 's/CDEBUG=-O -g/CDEBUG=${CFLAGS}/' Makefile.set.orig > Makefile.set
    cp Makefile.set Makefile.set.orig
    sed -e 's/DESTETC=\/etc/DESTETC=\/etc\/bind/' Makefile.set.orig > Makefile.set
    cd ${S}/bin
    cp Makefile Makefile.orig
    sed -e 's/CDEBUG= -g/#CDEBUG= -g/' Makefile.orig > Makefile
    cp Makefile Makefile.orig
    sed -e 's/CFLAGS=/#CFLAGS=/' Makefile.orig > Makefile
}

src_install() {
	into /usr
	for x in addr dig dnsquery host mkservdb nslookup nsupdate
	do
		dobin bin/${x}/${x}
	done	
	for x in dnskeygen irpd named named-bootconf named-xfer ndc
	do
		dosbin bin/${x}/${x}
	done

	dodoc CHANGES DNSSEC SUPPORT README LICENSE* TODO 
	docinto conf
	dodoc conf/README	
	docinto conf/recursive
	dodoc conf/recursive/* 
	docinto conf/recursive/pri
	dodoc conf/recursive/pri/* 
	docinto conf/workstation
	dodoc conf/workstation/* 
	docinto conf/workstation/pri
	dodoc conf/workstation/pri/* 
	dodir /etc/rc.d/init.d
	cp ${O}/files/named ${D}/etc/rc.d/init.d
	cp ${O}/files/named.conf ${D}/usr/doc/${P}/conf/workstation/named.conf.gentoolinux
	dodir /etc/bind
	dodir /var/bind
}

pkg_config() {

    . ${ROOT}/etc/rc.d/config/functions

    if [ -e ${ROOT}/etc/bind/named.conf ]; then
	echo "You already have a named.conf in ${ROOT}/etc/bind/named.conf, not creating one."
    else
	install -m0644 ${ROOT}/usr/doc/bind-8.2.2-P5/conf/workstation/named.conf.gentoolinux ${ROOT}/etc/bind/named.conf
	mkdir ${ROOT}/var/bind/pri
	gzip -d ${ROOT}/usr/doc/bind-8.2.2-P5/conf/workstation/root.cache.gz
	gzip -d ${ROOT}/usr/doc/bind-8.2.2-P5/conf/workstation/pri/*.gz
	install -m0644 ${ROOT}/usr/doc/bind-8.2.2-P5/conf/workstation/root.cache ${ROOT}/var/bind/root.cache
	install -m0644 ${ROOT}/usr/doc/bind-8.2.2-P5/conf/workstation/pri/* ${ROOT}/var/bind/pri/
    fi
    echo; 
    ${ROOT}/usr/sbin/rc-update add named 
    echo; einfo "BIND enabled."
}

