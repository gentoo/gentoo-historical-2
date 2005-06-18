# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/struts/struts-1.2.4-r1.ebuild,v 1.2 2005/06/18 14:52:47 luckyduck Exp $

inherit java-pkg

DESCRIPTION="A powerful Model View Controller Framework for JSP/Servlets"
SRC_URI="mirror://apache/struts/source/jakarta-${PN}-${PV}-src.tar.gz"
HOMEPAGE="http://jakarta.apache.org/struts/index.html"
LICENSE="Apache-2.0"
SLOT="0"
DEPEND=">=virtual/jdk-1.4
	>=dev-java/ant-1.6.0
	jikes? ( dev-java/jikes )
	source? ( app-arch/zip )"
RDEPEND=">=virtual/jre-1.4
	=dev-java/commons-beanutils-1.6*
	>=dev-java/commons-collections-2.1
	dev-java/struts-legacy
	>=dev-java/commons-digester-1.5
	>=dev-java/commons-fileupload-1.0
	>=dev-java/commons-lang-2.0
	>=dev-java/commons-logging-1.0.4
	>=dev-java/commons-validator-1.1.3
	=dev-java/jakarta-oro-2.0*
	=dev-java/servletapi-2.3*"
IUSE="doc examples jikes source"
KEYWORDS="~x86 ~ppc ~amd64"

S=${WORKDIR}/jakarta-${P}-src

src_compile() {
	local antflags="compile.library"
	use doc && antflags="${antflags} compile.javadoc"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"

	antflags="${antflags} -Dcommons-beanutils.jar=$(java-pkg_getjar	commons-beanutils-1.6 commons-beanutils.jar | sed s/:.*// )"
	antflags="${antflags} -Dcommons-collections.jar=$(java-pkg_getjar commons-collections commons-collections.jar)"
	antflags="${antflags} -Dstruts-legacy.jar=$(java-pkg_getjar struts-legacy struts-legacy.jar)"
	antflags="${antflags} -Dcommons-digester.jar=$(java-pkg_getjar commons-digester commons-digester.jar)"
	antflags="${antflags} -Dcommons-fileupload.jar=$(java-pkg_getjar commons-fileupload commons-fileupload.jar)"
	antflags="${antflags} -Djakarta-oro.jar=$(java-pkg_getjar jakarta-oro-2.0 jakarta-oro.jar)"
	antflags="${antflags} -Dservlet.jar=$(java-pkg_getjar servletapi-2.3 servlet.jar)"
	antflags="${antflags} -Dcommons-lang.jar=$(java-pkg_getjar commons-lang commons-lang.jar)"
	antflags="${antflags} -Dcommons-logging.jar=$(java-pkg_getjar commons-logging commons-logging.jar | sed 's/.*://')"
	antflags="${antflags} -Dcommons-validator.jar=$(java-pkg_getjar commons-validator commons-validator.jar)"

	ant ${antflags} || die "compile failed"
}


src_install() {
	java-pkg_dojar target/library/struts.jar

	#install the tld files
	insinto /usr/share/${PN}/lib
	doins target/library/*.tld

	dodoc README STATUS.txt
	use doc && java-pkg_dohtml -r target/documentation/
	if use examples; then
		dodir /usr/share/doc/${PF}/examples
		cp -r src/example*/* ${D}/usr/share/doc/${PF}/examples
	fi
	use source && java-pkg_dosrc src/share/*
}
