# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/hessian/hessian-3.0.8-r3.ebuild,v 1.5 2007/01/16 17:17:52 betelgeuse Exp $

inherit java-pkg-2 java-ant-2

DESCRIPTION="A binary web service protocol."
HOMEPAGE="http://www.caucho.com/hessian/"
SRC_URI="http://www.caucho.com/hessian/download/${P}-src.jar"

LICENSE="Apache-1.1"
SLOT="3.0.8"
KEYWORDS="amd64 x86"
IUSE="doc source"

COMMON_DEP="=dev-java/servletapi-2.3*
		~dev-java/caucho-services-${PV}"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
# FIXME doesn't like Java 1.5's XML APIs
DEPEND="=virtual/jdk-1.4*
	app-arch/unzip
	source? ( app-arch/zip )
	dev-java/ant-core
	${COMMON_DEP}"

src_unpack() {
	mkdir -p ${P}/src
	unzip -qq -d ${S}/src ${DISTDIR}/${A}

	# They package stuff from burlap in here
	# Burlap is a separate protocol
	rm -fr ${S}/src/com/caucho/burlap
	rm -fr ${S}/src/com/caucho/services

	cd ${S}
	# No included ant script! Bad Java developer, bad!
	cp ${FILESDIR}/build-${PV}.xml build.xml

	# Populate classpath
	echo "classpath=$(java-pkg_getjars servletapi-2.3):$(java-pkg_getjars caucho-services-3.0)" >> build.properties
}

src_compile() {
	eant -Dproject.name=${PN} jar $(use_doc)
}

src_install() {
	java-pkg_dojar dist/${PN}.jar

	use doc && java-pkg_dohtml -r dist/doc/api
	use source && java-pkg_dosrc src/com
}
