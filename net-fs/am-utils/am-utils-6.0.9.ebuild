# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-fs/am-utils/am-utils-6.0.9.ebuild,v 1.2 2003/06/03 07:35:22 absinthe Exp $

IUSE="ldap"

S=${WORKDIR}/${P}
DESCRIPTION="amd automounter and utilities"
HOMEPAGE="http://www.am-utils.org"
SRC_URI="ftp://ftp.am-utils.org/pub/am-utils/${P}.tar.gz"

DEPEND="virtual/glibc
	ldap? ( >=net-nds/openldap-1.2 )"

SLOT="0"
LICENSE="BSD"
KEYWORDS="x86"

src_compile() {
	local myconf
	
	use ldap \
		&& myconf="${myconf} --without-ldap" \
		|| myconf="${myconf} --with-ldap"
	
	myconf="${myconf} --sysconfdir=/etc/amd"
	
	cd ${S}
	econf ${myconf} || die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR=${D} install || die

    cp ${FILESDIR}/amd.conf ${D}/etc/amd
    cp ${FILESDIR}/amd.net ${D}/etc/amd

    exeinto /etc/init.d ; newexe ${FILESDIR}/amd.rc amd
}
