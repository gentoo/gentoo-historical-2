# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-mail/courier-imap/courier-imap-1.4.0.ebuild,v 1.1 2001/12/12 15:57:38 g2boojum Exp $

S=${WORKDIR}/${P}
DESCRIPTION="An IMAP daemon designed specifically for maildirs"
SRC_URI="http://ftp1.sourceforge.net/courier/${P}.tar.gz"
HOMEPAGE="http://www.courier-mta.org/"

DEPEND="virtual/glibc sys-devel/perl sys-apps/procps
        >=sys-libs/pam-0.75
	>=dev-libs/openssl-0.9.6
	ldap? ( >=net-nds/openldap-1.2.11 )
	mysql? ( >=dev-db/mysql-3.23.36 )
	berkdb? ( >=sys-libs/db-3.2 )
	gdbm? ( >=sys-libs/gdbm-1.8.0 )"

RDEPEND="virtual/glibc
	>=dev-libs/openssl-0.9.6
	pam? ( >=sys-libs/pam-0.75 )
	ldap? ( >=net-nds/openldap-1.2.11 )
	mysql? ( >=dev-db/mysql-3.23.36 )
	berkdb? ( >=sys-libs/db-3.2 )
	gdbm? ( >=sys-libs/gdbm-1.8.0 )"

#This package is complete if you just need basic IMAP functionality.  Here are some things that
#still need fixing:
#supervise support (of course)
#creation of imapd-ssl, pop3-ssl, pop3 init.d scripts (I only converted the imapd.rc script)
#tweaking of config files.
#My RC script is configured to look for maildirs in ~/.maildir (my preference, and the official
#Gentoo Linux standard location) instead of the more traditional and icky ~/Maildir.
#We need to add an /etc/mail.conf.

src_compile() {
	local myconf
	if [ -z "`use ldap`" ] ; then
	    myconf="--without-authldap"
	fi
	if [ -z "`use mysql`" ] ; then
	    myconf="$myconf --without-authmysql"
	fi
	if [ "`use berkdb`" ] ; then
	    myconf="$myconf --with-db=db"
	else
	    myconf="$myconf --with-db=gdbm"
	fi
	if [ -z "`use pam`" ] ; then
	    myconf="$myconf --without-authpam"
	fi
	./configure --sysconfdir=/etc/courier-imap --prefix=/usr \
	--bindir=/usr/sbin --libexecdir=/usr/lib/courier-imap \
	--localstatedir=/var/lib/courier-imap --mandir=/usr/share/man \
	--with-authdaemonvar=/var/lib/courier-imap/authdaemon \
	--disable-root-check $myconf || die
	emake || die
}

src_install () {
	dodir /var/lib/courier-imap
	mkdir -p ${D}/etc/pam.d
	make install DESTDIR=${D}
	# hack /usr/lib/courier-imap/imapd.rc to use ${Maildir}.
	cd ${D}/usr/lib/courier-imap
	cp imapd.rc imapd.rc.orig
	sed -e 's/Maildir/${MAILDIR}/' imapd.rc.orig > imapd.rc
	rm imapd.rc.orig
	cd ${D}/etc/courier-imap
	local x
	for x in pop3d pop3d-ssl imapd imapd-ssl
	do
		mv ${x}.dist ${x}
	done
	# add a value for ${MAILDIR} to /etc/courier-imap/imapd
	echo -e '\n#Hardwire a value for ${MAILDIR}' >> imapd
	echo 'MAILDIR=.maildir' >> imapd
	cd ${D}/usr/sbin
	for x in *
	do
		if [ -L ${x} ]
		then
			rm ${x}
		fi
	done
	cd ../share
	mv * ../sbin
        mv ../sbin/man .
	cd ..
	cd ${D}/etc/pam.d
	for x in *
	do
		cp ${x} ${x}.orig
		sed -e 's#/lib/security/##g' ${x}.orig > ${x}
		rm ${x}.orig
	done
	exeinto /etc/init.d
	newexe ${FILESDIR}/courier-imap-rc6 courier-imap
	newexe ${FILESDIR}/courier-imap-ssl-rc6 courier-imap-ssl
	rm ${D}/usr/sbin/mkimapdcert
	exeinto /usr/sbin
	doexe ${FILESDIR}/mkimapdcert	
	insinto /etc/pam.d
	doins ${FILEDIR}/pam.d-imap
}

