# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-mail/courier-imap/courier-imap-1.3.0.ebuild,v 1.1 2001/01/02 03:54:22 drobbins Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="An IMAP daemon designed specifically for maildirs"
SRC_URI="http://download.sourceforge.net/courier/${A}"
HOMEPAGE="http://www.courier-mta.org/"

DEPEND=">=sys-libs/glibc-2.1.3"

#This package is complete if you just need basic IMAP functionality.  Here are some things that
#still need fixing:
#supervise support (of course)
#creation of imapd-ssl, pop3-ssl, pop3 init.d scripts (I only converted the imapd.rc script)
#tweaking of config files.
#My RC script is configured to look for maildirs in ~/.maildir (my preference, and the official
#Gentoo Linux standard location) instead of the more traditional and icky ~/Maildir.
#We need to add an /etc/mail.conf.

src_compile() {
    cd ${S}
	try ./configure --sysconfdir=/etc/courier-imap --prefix=/usr --bindir=/usr/sbin --libexecdir=/usr/lib/courier-imap --localstatedir=/var/lib/courier-imap --with-authdaemonvar=/var/lib/courier-imap/authdaemon --without-authldap --with-db=db --disable-root-check
    try make
}

src_install () {
	cd ${S}
	mkdir -p ${D}/etc/pam.d
	make install DESTDIR=${D}
	cd ${D}/etc/courier-imap
	local x
	for x in pop3d pop3d-ssl imapd imapd-ssl
	do
		mv ${x}.dist ${x}
	done
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
	cd ..
	rm -rf share
	cd ${D}/etc/pam.d
	for x in *
	do
		cp ${x} ${x}.orig
		sed -e 's#/lib/security/##g' ${x}.orig > ${x}
		rm ${x}.orig
	done
	exeinto /etc/rc.d/init.d
	doexe ${FILESDIR}/courier-imap*
	rm ${D}/usr/sbin/mkimapdcert
	exeinto /usr/sbin
	doexe ${FILESDIR}/mkimapdcert	
}

pkg_config() {
    ${ROOT}/usr/sbin/rc-update add courier-imap 
}
