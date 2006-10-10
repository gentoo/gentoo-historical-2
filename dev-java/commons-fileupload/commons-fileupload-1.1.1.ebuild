# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-fileupload/commons-fileupload-1.1.1.ebuild,v 1.2 2006/10/10 20:39:41 caster Exp $

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="The Commons FileUpload package makes it easy to add robust, high-performance, file upload capability to your servlets and web applications."
HOMEPAGE="http://jakarta.apache.org/commons/fileupload/"
SRC_URI="mirror://apache/jakarta/commons/fileupload/source/${P}-src.tar.gz"
DEPEND=">=virtual/jdk-1.3
	>=dev-java/ant-core-1.5
	~dev-java/servletapi-2.3
	>=dev-java/commons-io-1.1
	=dev-java/portletapi-1*
	source? ( app-arch/unzip )"
RDEPEND=">=virtual/jre-1.3"
LICENSE="Apache-2.0"
SLOT="0"
# Missing dependencies: need package for javax.portlet.
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="doc source"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# Tweak build classpath and don't automatically run tests
	epatch "${FILESDIR}/${P}-gentoo.patch"
	local libdir="target/lib"
	mkdir -p ${libdir}/commons-io/jars -p  ${libdir}/javax.servlet/jars -p  ${libdir}/javax.portlet/jars
	cd ${libdir}/commons-io/jars
	java-pkg_jar-from commons-io-1
	cd "${S}"/${libdir}/javax.servlet/jars
	java-pkg_jar-from servletapi-2.3
	cd "${S}"/${libdir}/javax.portlet/jars
	java-pkg_jar-from portletapi-1
}

src_compile() {
	eant -Dlibdir="${S}"/target/lib jar -Dnoget=true $(use_doc)
}

src_install() {
	java-pkg_newjar target/${PN}-1.2-SNAPSHOT.jar ${PN}.jar
	use doc && java-pkg_dohtml -r dist/docs/
	use source && java-pkg_dosrc src/java/*
}
