# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-ftp/proftpd/proftpd-1.2.2_rc3.ebuild,v 1.4 2001/07/21 07:57:32 jerry Exp $

P=${PN}-1.2.2rc3
S=${WORKDIR}/${P}
DESCRIPTION="proftpd."
SRC_URI="ftp://ftp.proftpd.org/distrib/${P}.tar.bz2
     http://www.lastditcheffort.org/aah/src/mod_sql-3.2.2.tar.gz"
HOMEPAGE="http://www.proftpd.net/"

DEPEND="virtual/glibc
    pam? ( >=sys-libs/pam-0.75 )
    mysql? ( >=dev-db/mysql-3.23.26 )
    ldap? ( >=net-nds/openldap-1.2.11 )
    postgres? ( >=dev-db/postgresql-7.1 )"


src_unpack() {
    unpack ${P}.tar.bz2
    cd ${S}/contrib
    unpack mod_sql-3.2.2.tar.gz
}

src_compile() {                           
    local modules
    local myinc
    modules="mod_ratio:mod_readme:mod_linuxprivs"

    if [ "`use pam`" ]; then
        modules="$modules:mod_pam"
    fi

    if [ "`use mysql`" ]; then
        modules="$modules:mod_sql:mod_sql_mysql"
    elif [ "`use postgres`" ]; then
        modules="$modules:mod_sql:mod_sql_postgres"
        myinc="/usr/include/postgresql"
    fi

    if [ "`use ldap`" ]; then
        modules="$modules:mod_ldap"
    fi

    if [ "$myinc" ]; then
        myinc="--with-includes=$myinc"
    fi
    
    ./configure --host=${CHOST} --prefix=/usr --sbindir=/usr/sbin \
        --sysconfdir=/etc/proftpd --localstatedir=/var/run \
        --mandir=/usr/share/man --with-modules=$modules \
        --disable-sendfile --enable-shadow --enable-autoshadow $myinc

    try make
}

src_install() {                               
    try make install prefix=${D}/usr sysconfdir=${D}/etc/proftpd \
        mandir=${D}/usr/share/man localstatedir=${D}/var/run \
        sbindir=${D}/usr/sbin

    into /usr
    dodir /home/ftp
    dobin contrib/genuser.pl
    dodoc COPYING CREDITS ChangeLog NEWS
    dodoc README* contrib/README.mod_sql
    cd doc
    dodoc API Changes-1.2.0pre3 license.txt GetConf ShowUndocumented
    dodoc Undocumented.txt development.notes 
    docinto html
    dodoc *.html
    docinto rfc
    dodoc rfc/*.txt

    cp ${FILESDIR}/proftpd.conf ${D}/etc/proftpd

    insinto /etc/rc.d/init.d
    insopts -m 0755
    doins ${FILESDIR}/proftpd
}
