# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/nss_ldap/nss_ldap-202.ebuild,v 1.9 2005/02/03 06:45:40 robbat2 Exp $

inherit fixheadtails
DESCRIPTION="NSS LDAP Module"
HOMEPAGE="http://www.padl.com/OSS/nss_ldap.html"
SRC_URI="ftp://ftp.padl.com/pub/${P}.tar.gz"

DEPEND=">=net-nds/openldap-1.2.11"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="x86 sparc"
IUSE=""

src_unpack() {
	unpack ${A}
	# fix head/tail stuff
	ht_fix_file ${S}/Makefile.am ${S}/Makefile.in ${S}/depcomp ${S}/config.guess
}

src_compile() {

	econf \
		--enable-schema-mapping \
		--enable-rfc2307bis \
		--enable-extra-optimization || die

	emake UNIX_CAN_BUILD_STATIC=0 \
		OPTIMIZER="${CFLAGS}" || die
}

src_install() {

	dodir /usr/lib

	make \
		DESTDIR=${D} \
		install || die

	dosym /etc/openldap/ldap.conf /etc/ldap.conf

	dodoc ldap.conf ANNOUNCE NEWS ChangeLog AUTHORS COPYING
	dodoc CVSVersionInfo.txt README nsswitch.ldap
}
