# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/pam_krb5/pam_krb5-20030601-r1.ebuild,v 1.1 2005/01/28 20:13:13 rphillips Exp $

inherit eutils

MY_PN="${PN}_snap"
MY_PV="${PV:0:4}.${PV:4:2}.${PV:6:2}"
DESCRIPTION="Pam module for MIT Kerberos V and Heimdal"
SRC_URI_BASE="mirror://sourceforge/pam-krb5"
RESTRICT="nomirror"
SRC_URI="${SRC_URI_BASE}/${MY_PN}-${MY_PV}.tar.gz"
HOMEPAGE="http://pam-krb5.sourceforge.net/"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="~x86 ~ppc"
IUSE="afs"

DEPEND="virtual/krb5
	sys-libs/pam
	afs? ( net-fs/openafs )"

S="${WORKDIR}/${MY_PN}-${MY_PV}"

src_unpack() {
	unpack ${A}
}

src_compile() {
	local myconf
	use afs && myconf="${myconf} --with-krbafs=/usr"
	CFLAGS="$CFLAGS" CXXFLAGS="$CXXFLAGS" ./configure \
		--prefix=/usr \
		--sysconfdir=/etc \
		--localstatedir=/var \
		--with-pamdir=/lib/security \
		--with-krb5=/usr \
		--host=${CHOST} ${myconf} || die "./configure failed."
	make CFLAGS="$CFLAGS" || die
}

src_install() {
	exeinto /lib/security
	doexe .libs/pam_krb5.so

	if use afs ; then
		if [ -f .libs/pam_krb5afs.so ]; then
			doexe .libs/pam_krb5afs.so
			doman pam_krb5afs.5 pam_krb5afs.8
		fi
	fi

	doman pam_krb5.5 pam_krb5.8

	dodoc AUTHORS ChangeLog COPYING INSTALL NEWS README README.heimdal TODO

	docinto pam.d
	dodoc pam.d/*
}
