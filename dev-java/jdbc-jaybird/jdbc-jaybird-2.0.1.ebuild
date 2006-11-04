# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jdbc-jaybird/jdbc-jaybird-2.0.1.ebuild,v 1.8 2006/11/04 23:45:48 opfer Exp $

inherit eutils java-pkg-2

At="JayBird-${PV}-src"
DESCRIPTION="JDBC Type 2 and 4 drivers for Firebird SQL server"
HOMEPAGE="http://jaybirdwiki.firebirdsql.org/"
SRC_URI="mirror://sourceforge/firebird/${At}.zip"
LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="doc examples source test"

COMMON_DEPEND="dev-java/log4j"
RDEPEND="|| ( =virtual/jre-1.4* =virtual/jre-1.5* )
		${COMMON_DEPEND}"
DEPEND="|| ( =virtual/jdk-1.4* =virtual/jdk-1.5* )
		app-arch/unzip
		dev-java/cpptasks
		test? (
			dev-java/junit
			dev-java/ant
		)
		!test? ( dev-java/ant-core )
		source? ( app-arch/zip )
		${COMMON_DEPEND}"

S="${WORKDIR}/client-java"

MY_PN="jaybird"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# make compiling of tests and examples optional, fix source/target
	# disable checking for jdk version - default all to 1.4
	# note that java-ant-2.eclass xml rewriting breaks here
	epatch "${FILESDIR}/archive-xml-${PV}.patch"
	epatch "${FILESDIR}/compile-xml-${PV}.patch"
	epatch "${FILESDIR}/dist-xml-${PV}.patch"

	cd "${S}/lib/"
	rm -v *.jar
	use test && java-pkg_jar-from --build-only junit junit.jar

	cd "${S}/src/lib/"
	# the build.xml unpacks this and uses stuff
	mv mini-j2ee.jar ${T} || die "Failed to move mini-j2ee.jar to ${T}"
	rm -v *.jar *.zip
	mv ${T}/mini-j2ee.jar . || die "Failed to move mini-j2ee.jar back from ${T}"

	java-pkg_jar-from log4j log4j.jar log4j-core.jar
}

src_compile() {
	eant $(use test && echo "-Dtests=true") jars compile-native \
		$(use_doc javadocs)
}

src_install() {
	cd "${S}/output/lib/"
	java-pkg_newjar ${MY_PN}-${PV}.jar ${PN}.jar

	for jar in full pool; do
		java-pkg_newjar ${MY_PN}-${jar}-${PV}.jar ${MY_PN}-${jar}.jar || die "java-pkg_newjar ${MY_PN}-${jar}.jar failed"
	done
	if use test; then
		java-pkg_newjar ${MY_PN}-test-${PV}.jar ${MY_PN}-${jar}.jar || die "java-pkg_newjar ${MY_PN}-${jar}.jar failed"
	fi

	cd "${S}/output/native"
	sodest="/usr/lib/"
	java-pkg_doso libjaybird2.so || die "java-pkg_doso ${sodest}libjaybird2.so failed"

	cd "${S}"

	if use examples; then
		insinto /usr/share/doc/${PF}/
		doins -r examples || die "installing examples failed"
	fi

	use source && java-pkg_dosrc "${S}"/src/*/org

	cd "${S}/output"
	use doc && java-pkg_dojavadoc docs
	dodoc etc/FAQ.txt
	dohtml etc/*.html
}

src_test() {
	#
	# Warning about timeouts without Firebird installed and running Locally
	#
	ewarn "You will experience long timeouts when running junit tests"
	ewarn "without Firebird installed and running locally. The tests will"
	ewarn "complete without Firebird, but network timeouts prolong the"
	ewarn "testing phase considerably."
	eant all-tests-pure-java
}
