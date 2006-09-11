# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/openspml/openspml-0.5.ebuild,v 1.1 2006/09/11 14:13:10 nelchael Exp $

inherit java-pkg-2 java-ant-2

MY_PV=${PV/_/}

DESCRIPTION="Open source implementation of Service Provisioning Markup Language (SPML)"
HOMEPAGE="http://www.openspml.org/"
SRC_URI="http://www.openspml.org/Files/${PN}_v${PV}.zip"

LICENSE="openspml"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc source"

RDEPEND=">=virtual/jre-1.4"
DEPEND="${RDEPEND}
	>=virtual/jdk-1.4"

S="${WORKDIR}/${PN}"

src_unpack() {

	unpack "${A}"

	# Argh...
	cd "${S}"
	find . -type f -exec chmod 644 {} \;
	find . -type d -exec chmod 755 {} \;

	cp "${FILESDIR}/build.xml-${PV}" "${S}/build.xml"

}

src_compile() {

	cd "${S}/lib"

	cd "${S}"
	eant jar

}

src_install() {

	java-pkg_dojar "${S}/lib/openspml.jar"

	use source && java-pkg_dosrc "${S}/src/*"
	dodoc README history.txt
	use doc && java-pkg_dohtml -r doc

}
