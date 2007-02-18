# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jdbc-postgresql/jdbc-postgresql-8.2_p504.ebuild,v 1.7 2007/02/18 10:20:29 nixnut Exp $

inherit java-pkg-2 java-ant-2

MY_PN="postgresql-jdbc"
MY_PV="${PV/_p/-}"
MY_P="${MY_PN}-${MY_PV}.src"

DESCRIPTION="JDBC Driver for PostgreSQL"
SRC_URI="http://jdbc.postgresql.org/download/${MY_P}.tar.gz"
HOMEPAGE="http://jdbc.postgresql.org/"

LICENSE="POSTGRESQL"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86 ~x86-fbsd"
IUSE="doc java5 source test"

DEPEND=">=dev-java/java-config-2.0.31
	!java5? ( =virtual/jdk-1.4* )
	java5? ( =virtual/jdk-1.5* )
	doc? ( dev-libs/libxslt
		app-text/docbook-xsl-stylesheets )
	source? ( app-arch/zip )
	!test? ( >=dev-java/ant-core-1.6 )
	test? ( =dev-java/junit-3.8*
		>=dev-java/ant-1.6
		dev-db/postgresql )"
RDEPEND=">=virtual/jre-1.4"

S="${WORKDIR}/${MY_P}"


pkg_setup() {
	if use java5; then
		JAVA_PKG_NV_DEPEND="=virtual/jdk-1.5*"

		# We must specify source/target versions because currently it is not
		# correctly picked up from NV_DEPEND for build.xml rewrite
		JAVA_PKG_WANT_SOURCE="1.5"
		JAVA_PKG_WANT_TARGET="1.5"
	else
		JAVA_PKG_NV_DEPEND="=virtual/jdk-1.4*"
	fi

	java-pkg-2_pkg_setup
}

src_unpack() {
	unpack ${A}

	# patch to make junit test work + correction for doc target
	cd ${S}
	epatch ${FILESDIR}/${P}-build.xml.patch

	mkdir lib
	cd lib
	java-pkg_jar-from junit
}

src_compile() {
	eant jar $(use_doc publicapi)

	# There is a task that creates this doc but I didn't find a way how to use system catalog
	# to lookup the stylesheet so the 'doc' target is rewritten here to use system call instead.
	if use doc; then
		mkdir -p ${S}/build/doc
		xsltproc -o ${S}/build/doc/pgjdbc.html http://docbook.sourceforge.net/release/xsl/current/xhtml/docbook.xsl \
			${S}/doc/pgjdbc.xml
	fi
}

src_install() {
	java-pkg_newjar jars/postgresql.jar jdbc-postgresql.jar

	if use_doc; then
		java-pkg_dojavadoc build/publicapi
		java-pkg_dohtml build/doc/pgjdbc.html
	fi

	use source && java-pkg_dosrc org
}

src_test() {
	einfo "In order to run the tests successfully, you have to have:"
	einfo "1) PostgreSQL server running"
	einfo "2) database 'test' defined with user 'test' with password 'password'"
	einfo "   as owner of the database"
	einfo "3) plpgsql support in the 'test' database"
	einfo
	einfo "You can find a general info on how to perform these steps at"
	einfo "http://gentoo-wiki.com/HOWTO_Configure_Postgresql"

	ANT_TASKS="ant-junit" eant test
}
