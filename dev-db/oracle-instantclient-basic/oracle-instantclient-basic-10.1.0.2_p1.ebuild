# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/oracle-instantclient-basic/oracle-instantclient-basic-10.1.0.2_p1.ebuild,v 1.5 2006/01/19 21:47:28 nelchael Exp $

inherit eutils

MY_PV=${PV/_p/-}
MY_P="${PN}-${MY_PV}.i386"

S=${WORKDIR}
DESCRIPTION="Oracle 10g client installation for Linux"
HOMEPAGE="http://otn.oracle.com/software/tech/oci/instantclient/htdocs/linuxsoft.html"
SRC_URI="${MY_P}.rpm"

LICENSE="OTN"
SLOT="${PV}"
KEYWORDS="~x86"
RESTRICT="fetch"
IUSE=""

DEPEND="app-arch/rpm2targz"

pkg_nofetch() {
	eerror "Please go to:"
	eerror "  ${HOMEPAGE}"
	eerror "and download the Basic client package.  Put it in:"
	eerror "  ${DISTDIR}"
	eerror "after downloading it."
}

src_unpack() {
	rpm2targz ${DISTDIR}/${MY_P}.rpm
	tar zxf ${WORKDIR}/${MY_P}.tar.gz
}

src_install() {
	dodir /usr/lib/oracle/10.1.0.2/client/lib
	cd ${S}/usr/lib/oracle/10.1.0.2/client/lib
	insinto /usr/lib/oracle/10.1.0.2/client/lib
	doins *.jar *.so *.so.10.1
}

pkg_postinst() {
	echo
	einfo "The Basic client page for Oracle 10g has been installed."
	einfo "You may also wish to install the oracle-instantclient-jdbc (for"
	einfo "supplemental JDBC functionality with Oracle) and the"
	einfo "oracle-instantclient-sqlplus (for running the SQL*Plus application)"
	einfo "packages as well."
	echo
}
