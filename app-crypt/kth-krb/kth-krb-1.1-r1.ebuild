# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Mikael Hallendal <micke@hallendal.net>
# $Header: /var/cvsroot/gentoo-x86/app-crypt/kth-krb/kth-krb-1.1-r1.ebuild,v 1.1 2002/01/07 09:54:11 hallski Exp $

S=${WORKDIR}/krb4-${PV}
DESCRIPTION="Kerberos 4 implementation from KTH"
SRC_URI="ftp://ftp.pdc.kth.se/pub/krb/src/krb4-${PV}.tar.gz"
HOMEPAGE="http://www.pdc.kth.se/kth-krb/"

DEPEND="virtual/glibc
	ssl? ( >=dev-libs/openssl-0.9.6b )
	afs? ( >=net-fs/openafs-1.2.2-r7 )"

src_compile() {
	local myconf

	myconf=""

	if [ "`use ssl`" ] ; then 
		myconf="${myconf} --with-openssl=/usr"
	fi

	if [ -z "`use afs`" ] ; then
		myconf="${myconf} --without-afs-support"
	fi

	./configure --host=${CHOST} \
			--prefix=/usr/athena \
			--sysconfdir=/etc \
			${myconf} || die

	emake || die
}

src_install () {
	make prefix=${D}/usr/athena \
		sysconfdir=${D}/etc \
		install || die

	# Doesn't get install otherwise (for some reason, look into this).
	if [ "`use ssl`" ] ; then
		cd ${S}/lib/des

		make prefix=${D}/usr/athena \
	 		install || die

		cd ${S}
	fi

	dodir /etc/env.d
	cp ${FILESDIR}/02kth-krb ${D}/etc/env.d

	dodoc COPYRIGHT ChangeLog README NEWS PROBLEMS TODO
}



