# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/nss_ldap/nss_ldap-215.ebuild,v 1.3 2004/06/24 23:16:38 agriffis Exp $

inherit fixheadtails

IUSE="berkdb debug"

DESCRIPTION="NSS LDAP Module"
HOMEPAGE="http://www.padl.com/OSS/nss_ldap.html"
SRC_URI="http://www.padl.com/download/${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="~x86 ~sparc amd64"

DEPEND=">=net-nds/openldap-1.2.11
	berkdb? ( >=sys-libs/db-3 )"

src_unpack() {
	unpack ${A}
	# fix head/tail stuff
	ht_fix_file ${S}/Makefile.am ${S}/Makefile.in ${S}/depcomp ${S}/config.guess
}

src_compile() {
	local myconf=""
	# --enable-schema-mapping   enable attribute/objectclass mapping
	# --enable-paged-results    enable paged results control

	use berkdb && myconf="${myconf} --enable-rfc2307bis"

	use debug && myconf="${myconf} --enable-debugging"

	econf \
		--with-ldap-lib=openldap \
		--libdir=/lib \
		${myconf} || die "configure failed"

	emake || die "make failed"
}

src_install() {
	dodir /lib

	make DESTDIR=${D} install || die "make install failed"

	insinto /etc
	doins ldap.conf

	dodoc ldap.conf ANNOUNCE NEWS ChangeLog AUTHORS \
		COPYING CVSVersionInfo.txt README nsswitch.ldap \
		LICENSE*
	docinto docs; dodoc doc/*
}
