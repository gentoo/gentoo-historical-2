# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-libs/pam_ldap/pam_ldap-134.ebuild,v 1.1 2001/12/02 12:44:59 azarah Exp $

S=${WORKDIR}/${P}
DESCRIPTION="PAM LDAP Module"
HOMEPAGE="http://www.padl.com/pam_ldap.html"
SRC_URI="ftp://ftp.padl.com/pub/${P}.tar.gz"

DEPEND=">=sys-libs/glibc-2.1.3
	>=sys-libs/pam-0.72
	>=net-nds/openldap-1.2.11"


src_compile() {                           

	./configure --host=${CHOST} \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--sysconfdir=/etc \
		--localstatedir=/var/lib \
		--with-ldap-lib=openldap || die

	emake || die
}

src_install() {                               

	exeinto /lib/security
	doexe pam_ldap.so
  
	dodoc pam.conf ldap.conf
	dodoc ChangeLog COPYING.* CVSVersionInfo.txt README
	docinto pam.d
	dodoc pam.d/*
}

