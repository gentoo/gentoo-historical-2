# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-www/apache-ssl/apache-ssl-1.3.14.2.7.0.ebuild,v 1.1 2000/10/14 12:30:17 achim Exp $

A="apache_1.3.14.tar.gz mod_ssl-2.7.0-1.3.14.tar.gz"
S=${WORKDIR}/apache_1.3.14
DESCRIPTION="The Apache Web Server v1.3.14 with mod_ssl"
SRC_URI="http://httpd.apache.org/dist/apache_1.3.14.tar.gz
	 ftp://ftp.modssl.org/source/mod_ssl-2.7.0-1.3.14.tar.gz"
HOMEPAGE="http://www.apache.org http://www.modssl.org"


src_compile() {                           
   export SSL_BASE=SYSTEM
   cd ${S}/../mod_ssl-2.7.0-1.3.14
    try ./configure --with-apache=${S} --with-ssl=SYSTEM
   cd ${S}
   try ./configure --prefix=/usr/local/httpd --bindir=/usr/bin \
	--sbindir=/usr/sbin --datadir=/usr/local/httpd \
	--sysconfdir=/etc/httpd --libexecdir=/usr/lib/apache \
	--mandir=/usr/man --logfiledir=/var/log/apache --localstatedir=/var/lock \
	--proxycachedir=/var/cache/httpd --includedir=/usr/include/apache \
	--enable-module=all --enable-module=ssl \
	--enable-shared=max --enable-suexec --suexec-caller=wwwrun \
	--suexec-userdir=public_html --suexec-uidmin=96 \
	--suexec-gidmin=96 --suexec-safepath="/bin:/usr/bin"
    try make
}

src_install() { 
    cd ${S}
    try make install-quiet root=${D}
    prepman

    dodoc ABOUT_APACHE Announcement INSTALL* KEYS LICENSE* README* WARNING*
    docinto mod_ssl
    cd ../mod_ssl-2.7.0-1.3.14
    dodoc ANNOUNCE CHANGES CREDITS INSTALL* LICENSE NEWS README*
    dodir /etc/rc.d/init.d
    cp ${O}/files/httpd.conf ${D}/etc/httpd
    cp ${O}/files/httpd	${D}/etc/rc.d/init.d
}

pkg_config() {

  source ${ROOT}/var/db/pkg/install.config

  # Make apache start at boot
  ${ROOT}/usr/sbin/rc-update add httpd

  # Set ServerName and ServerAdmin
  einfo "Setting Servername to $ServerName..."
  cp ${ROOT}/etc/httpd/httpd.conf ${ROOT}/etc/httpd/httpd.conf.orig
  sed -e "s/^\#ServerName.*/ServerName $ServerName/" \
      -e "s/^ServerName.*/ServerName $ServerName/" \
      -e "s/^ServerAdmin.*/ServerAdmin $ServerAdmin/" \
	${ROOT}/etc/httpd/httpd.conf.orig > ${ROOT}/etc/httpd/httpd.conf

}



