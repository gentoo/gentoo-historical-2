# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-ftp/proftpd/proftpd-1.2.0rc2-r1.ebuild,v 1.1 2000/08/08 19:14:24 achim Exp $

P=proftpd-1.2.0rc2
A="${P}.tar.gz"
S=${WORKDIR}/${P}
DESCRIPTION="proftpd."
CATEGORY=net-ftp
SRC_URI="ftp://ftp.nl.uu.net/pub/unix/ftp/proftpd/${P}.tar.gz"
HOMEPAGE="http://www.proftpd.net/"

src_unpack() {
   unpack ${A}
}

src_compile() {                           
    CFLAGS="$CFLAGS -I/usr/include/mysql" ./configure --host=${CHOST} --prefix=/usr --sbindir=/usr/sbin \
		--sysconfdir=/etc --localstatedir=/var/run --mandir=/usr/man \
		--with-modules=mod_ldap:mod_ratio:mod_readme:mod_linuxprivs:mod_mysql:mod_sqlpw:mod_pam \
		--disable-sendfile --enable-shadow --enable-autoshadow
    make clean
    make

}

src_install() {                               
     make install prefix=${D}/usr sysconfdir=${D}/etc/proftp mandir=${D}/usr/man \
	localstatedir=${D}/var/run sbindir=${D}/usr/sbin
     prepman

     cd ${S}
     into /usr
     dobin contrib/genuser.pl
     dodoc COPYING CREDITS ChangeLog NEWS
     dodoc README*
     cd doc
     dodoc API Changes-1.2.0pre3 license.txt GetConf ShowUndocumented
     dodoc Undocumented.txt development.notes 
     docinto html
     dodoc *.html
     docinto rfc
     dodoc rfc/*.txt
     cp ${O}/files/proftpd.conf ${D}/etc/proftp
}




