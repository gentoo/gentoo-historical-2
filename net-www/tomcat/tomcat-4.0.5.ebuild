# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/tomcat/tomcat-4.0.5.ebuild,v 1.5 2002/12/09 04:33:20 manson Exp $

S=${WORKDIR}/jakarta-${P}
DESCRIPTION="Apache Servlet Engine"
SRC_URI="http://jakarta.apache.org/builds/jakarta-tomcat-4.0/release/v${PV}/bin/jakarta-tomcat-${PV}.tar.gz"
HOMEPAGE="http://jakarta.apache.org/tomcat"
KEYWORDS="x86 ppc sparc  alpha"
LICENSE="Apache-1.1"
SLOT="0"
DEPEND=">=virtual/jdk-1.2"

src_install() {
	dodir /opt/jakarta/tomcat
	dodir /opt/jakarta/tomcat/logs
	touch ${D}/opt/jakarta/tomcat/logs/.keep
	dodoc RELEASE-NOTES-* README.txt RUNNING.txt LICENSE
	cp -Rdp bin common conf lib server webapps work ${D}/opt/jakarta/tomcat
	dodir /etc/env.d
	insinto /etc/env.d
	doins ${FILESDIR}/21tomcat
}

