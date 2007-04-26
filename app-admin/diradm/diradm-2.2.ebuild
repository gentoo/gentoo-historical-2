# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/diradm/diradm-2.2.ebuild,v 1.6 2007/04/26 02:58:06 robbat2 Exp $

DESCRIPTION="diradm is for managing posix users/groups in an LDAP directory"
BASE_URI="http://research.iat.sfu.ca/custom-software/"
HOMEPAGE="http://www.hits.at/diradm/"
SRC_URI="${BASE_URI}/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE="samba"
DEPEND="net-nds/openldap
	virtual/perl-MIME-Base64
	samba? (
		dev-perl/Crypt-SmbHash
		>=net-fs/samba-3
	)"

src_compile() {
	local myconf
	myconf="`use_enable samba`"
	econf ${myconf} || die
	emake
}

src_install() {
	make install DESTDIR="${D}" || die
	dodoc CHANGES* README AUTHORS ChangeLog NEWS README.prefork THANKS
}

pkg_postinst() {
	elog "The new diradm pulls many settings from your LDAP configuration."
	elog "But don't forget to customize /etc/diradm.conf for other settings."
}
