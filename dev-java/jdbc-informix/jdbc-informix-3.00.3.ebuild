# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jdbc-informix/jdbc-informix-3.00.3.ebuild,v 1.5 2007/12/09 13:23:06 nelchael Exp $

JAVA_PKG_IUSE="doc examples"

inherit versionator java-pkg-2

MY_PV="$(replace_version_separator 2 .JC)"

At="JDBC.${MY_PV}.tar"
DESCRIPTION="JDBC Type 4 Drivers for Informix"
SRC_URI="${At}"
HOMEPAGE="http://www.ibm.com/software/data/informix/tools/jdbc/"
DOWNLOADPAGE="http://www14.software.ibm.com/webapp/download/search.jsp?go=y&rs=ifxjdbc"
KEYWORDS="amd64 ppc x86"
LICENSE="informix-jdbc"
SLOT="0"
DEPEND=">=virtual/jre-1.4"
RDEPEND=">=virtual/jre-1.4"
RESTRICT="fetch"
IUSE=""

S="${WORKDIR}"

pkg_nofetch() {
	einfo "Due to licensing restrictions, you need to download the distfile manually."
	einfo "Please navigate to ${DOWNLOADPAGE}"
	einfo "Click on the 'Informix JDBC Driver' link, version ${MY_PV}"
	einfo "Sign up with your IBM account (you need to register)."
	einfo "Go through the license agreement and survey."
	einfo "Download ${At} and place it into ${DISTDIR}"
	einfo "And restart the installation."
}

src_compile() {
	einfo "Performing silent installation"
	addpredict /root/vpd.properties
	java -jar setup.jar -P product.installLocation=. -silent
	if use examples; then
		einfo "Cleaning compiled examples"
		find demo \( -name \*.so -o -name \*.class -o -name \*.dll \) -delete
	fi
}

src_install() {
	java-pkg_dojar lib/*.jar

	# these are to be copied to app server as servlets
	insinto /usr/share/${PN}/
	doins -r proxy

	if use doc; then
		java-pkg_dojavadoc doc/javadoc
		dodoc doc/release/jdbc4pg.pdf doc/release/sqlj/ifxsqljug.pdf || die
		dohtml -r doc/release/* || die
	fi

	use examples && java-pkg_doexamples demo
}
