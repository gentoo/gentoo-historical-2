# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-nds/migrationtools/migrationtools-45.ebuild,v 1.1 2004/05/25 01:49:08 g2boojum Exp $

PN0=MigrationTools
S=${WORKDIR}/${PN0}-${PV}
DESCRIPTION="PADL migration tools (scripts) for openldap"
SRC_URI="http://www.padl.com/download/${PN0}-${PV}.tar.gz"
HOMEPAGE="http://www.padl.com/OSS/MigrationTools.html"

SLOT="0"
KEYWORDS="~x86 ~sparc ~amd64"
LICENSE="as-is"
IUSE=""

DEPEND=""
RDEPEND="net-nds/openldap
		 dev-lang/perl"

src_install() {
	dodoc README
	dodir /usr/share/migrationtools
	cp -a ${S}/migrate_* ${D}/usr/share/migrationtools
	dodir /usr/share/migrationtools/ads
	cp -a ${S}/ads/* ${D}/usr/share/migrationtools/ads
}
