# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/servletapi/servletapi-2.4.ebuild,v 1.14 2004/10/17 07:31:29 absinthe Exp $

inherit java-pkg

DESCRIPTION="Servlet API 5 from jakarta.apache.org"
HOMEPAGE="http://jakarta.apache.org/"
SRC_URI="mirror://apache/jakarta/tomcat-5/v5.0.19/src/jakarta-tomcat-5.0.19-src.tar.gz"
DEPEND=">=virtual/jdk-1.4
			  >=dev-java/ant-1.5
		jikes? ( dev-java/jikes )"
RDEPEND=">=virtual/jdk-1.4"
LICENSE="Apache-1.1"
SLOT="2.4"
KEYWORDS="x86 ~sparc ppc ~amd64"
IUSE="jikes doc"

S=${WORKDIR}/jakarta-tomcat-5.0.19-src/jakarta-servletapi-5

src_compile() {
	antflags="jar"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	use doc && antflags="${antflags} javadoc examples"
	ant ${antflags} -f jsr154/build.xml || die "compilation problem"
	ant ${antflags} -f jsr152/build.xml || die "compilation problem"
}

src_install () {
	mv jsr{154,152}/dist/lib/*.jar ${S}

	if use doc ; then
		mkdir docs
		cd ${S}/jsr154/dist
		mv docs ${S}/docs/servlet
		mv examples ${S}/docs/servlet/examples

		cd ${S}/jsr152/dist
		mv docs ${S}/docs/jsp
		mv examples ${S}/docs/jsp/examples
	fi

	cd ${S}
	java-pkg_dojar *.jar || die "Unable to install"
	use doc && java-pkg_dohtml -r docs/*
}

