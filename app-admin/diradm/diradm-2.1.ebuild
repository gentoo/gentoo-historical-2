# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/diradm/diradm-2.1.ebuild,v 1.1 2004/12/23 23:00:17 robbat2 Exp $

DESCRIPTION="diradm is for managing posix users/groups in an LDAP directory"
BASE_URI="http://research.iat.sfu.ca/custom-software/"
HOMEPAGE="${BASE_URI}/${PN}"
SRC_URI="${BASE_URI}/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE="samba"
DEPEND="net-nds/openldap
	sys-apps/gawk
	sys-apps/coreutils
	sys-apps/grep
	dev-lang/perl
	app-shells/bash
	sys-apps/sed
	dev-perl/MIME-Base64
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
	dodoc CHANGES* README AUTHORS COPYING ChangeLog NEWS README.prefork THANKS
}

pkg_postinst() {
	einfo "The new diradm pulls many settings from your LDAP configuration."
	einfo "But don't forget to customize /etc/diradm.conf for other settings."
}
