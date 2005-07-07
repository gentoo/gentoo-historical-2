# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/pam_ldap/pam_ldap-178-r1.ebuild,v 1.5 2005/07/07 10:32:17 corsair Exp $

inherit eutils

DESCRIPTION="PAM LDAP Module"
HOMEPAGE="http://www.padl.com/OSS/pam_ldap.html"
SRC_URI="http://www.padl.com/download/${P}.tar.gz"

LICENSE="|| ( GPL-2 LGPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~hppa ppc ~ppc64 sparc ~x86"
IUSE="ssl"
DEPEND=">=sys-libs/glibc-2.1.3
	>=sys-libs/pam-0.72
	>=net-nds/openldap-2.1.30-r5"

src_unpack() {
	unpack ${A}
	EPATCH_OPTS="-p1 -d ${S}" epatch ${FILESDIR}/${PN}-176-fix-referral-tls.patch

	cd ${S}
	export WANT_AUTOCONF=2.5
	aclocal || die "aclocal failed"
	autoconf || die "autoconf failed"
	automake --add-missing || die "automake failed"
}

src_compile() {
	econf --with-ldap-lib=openldap `use_enable ssl` || die
	emake || die
}

src_install() {
	exeinto /lib/security
	doexe pam_ldap.so

	dodoc pam.conf ldap.conf ldapns.schema chsh chfn certutil
	dodoc ChangeLog COPYING.* CVSVersionInfo.txt README AUTHORS ns-pwd-policy.schema
	docinto pam.d
	dodoc pam.d/*
}
