# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/pure-ftpd/pure-ftpd-1.0.8-r1.ebuild,v 1.7 2002/10/05 05:39:18 drobbins Exp $

IUSE="ldap pam postgres mysql"

S=${WORKDIR}/${P}
HOMEPAGE="http://pureftpd.sourceforge.net/"
SRC_URI="mirror://sourceforge/pureftpd/${P}.tar.gz"
DESCRIPTION="Pure-FTPd is a fast, production-quality, standard-conformant FTP server"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc sparc64"

DEPEND="virtual/glibc
	pam? ( >=sys-libs/pam-0.75 )
	mysql? ( >=dev-db/mysql-3.23.47 )
	postgres? ( >=dev-db/postgresql-7.1.3 )
	ldap? ( >=net-nds/openldap-2.0.21 )"

src_compile() {

	local myconf
	cd ${S}
	use pam && myconf="${myconf} --with-pam"
	use mysql && myconf="${myconf} --with-mysql"
	use postgres && myconf="${myconf} --with-pgsql"
	use ldap && myconf="${myconf} --with-ldap"
	./configure --prefix=/usr --with-altlog --with-puredb		\
		--with-extauth --with-throttling --with-ratios		\
		--with-quotas --with-cookie				\
		--with-uploadscript --with-virtualhosts			\
		--with-virtualchroot --with-diraliases --with-ftpwho	\
		--host=${CHOST} ${myconf} || die
	emake || die

}

src_install() {

	make DESTDIR=${D} install || die
	mkdir -p ${D}/etc
	cp ${FILESDIR}/ftpusers ${D}/etc/ftpusers
	mkdir -p ${D}/etc/conf.d
	cp ${FILESDIR}/pure-ftpd.conf_d ${D}/etc/conf.d/pure-ftpd
	mkdir -p ${D}/etc/init.d
	cp ${FILESDIR}/pure-ftpd.rc6 ${D}/etc/init.d/pure-ftpd		
	chmod 755 ${D}/etc/init.d/pure-ftpd
	
}

