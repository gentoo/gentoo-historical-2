# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/app-crypt/heimdal/heimdal-0.4e-r1.ebuild,v 1.7 2002/09/09 07:54:55 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Kerberos 5 implementation from KTH"
SRC_URI="ftp://ftp.pdc.kth.se/pub/${PN}/src/${P}.tar.gz"
HOMEPAGE="http://www.pdc.kth.se/heimdal/"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 sparc sparc64"

DEPEND=">=app-crypt/kth-krb-1.1-r1
	ssl? ( dev-libs/openssl )
	ldap? ( net-nds/openldap )
	berkdb? ( sys-libs/db )"

src_compile() {
	local myconf

	use ssl && myconf="--with-openssl=/usr"

	use ldap && myconf="${myconf} --with-open-ldap=/usr"

	use ipv6 || myconf="${myconf} --without-ipv6"

	use berkdb || myconf="${myconf} --without-berkely-db"

	./configure --host=${CHOST} \
		--prefix=/usr/heimdal \
		--sysconfdir=/etc \
		--with-krb4=/usr/athena \
		${myconf} || die

	make || die
}

src_install () {
	make prefix=${D}/usr/heimdal \
		sysconfdir=${D}/etc \
		install || die

	dodir /etc/env.d
	cp ${FILESDIR}/01heimdal ${D}/etc/env.d

	dodoc COPYRIGHT ChangeLog README NEWS PROBLEMS TODO
}
