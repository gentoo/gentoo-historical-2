# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/sun-jmx/sun-jmx-1.2.1-r3.ebuild,v 1.6 2008/07/21 18:40:26 ken69267 Exp $

JAVA_PKG_IUSE="doc examples"

inherit java-pkg-2

MY_P=jmx-${PV//./_}
DESCRIPTION="Java Management Extensions for managing and monitoring devices, applications, and services."
HOMEPAGE="http://java.sun.com/products/JavaManagement/index.jsp"
SRC_URI="${MY_P}-ri.zip"
LICENSE="sun-bcla-jmx"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~x86"

DEPEND=">=virtual/jdk-1.4
	app-arch/unzip"
RDEPEND=">=virtual/jre-1.4"
RESTRICT="fetch"

S="${WORKDIR}/${MY_P}-bin"
IUSE=""

DOWNLOADSITE="https://cds.sun.com/is-bin/INTERSHOP.enfinity/WFS/CDS-CDS_Developer-Site/en_US/-/USD/ViewProductDetail-Start?ProductRef=7657-jmx-1.2.1-oth-JPR@CDS-CDS_Developer"

src_compile() { :; }

pkg_nofetch() {
	einfo
	einfo " Due to license restrictions, we cannot fetch the"
	einfo " distributables automagically."
	einfo
	einfo " 1. Visit ${DOWNLOADSITE} and follow instructions"
	einfo " 2. Download ${SRC_URI}"
	einfo " 3. Move file to ${DISTDIR}"
	einfo " 4. Run emerge on this package again to complete"
	einfo
}

src_install() {
	java-pkg_dojar lib/*.jar
	if use doc; then
		java-pkg_dojavadoc doc/api
		java-pkg_dohtml -r doc/doc doc/index.html
	fi
	use examples && java-pkg_doexamples examples
}
