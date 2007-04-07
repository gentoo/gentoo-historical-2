# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/javahelp/javahelp-2.0.02_p46.ebuild,v 1.3 2007/04/07 16:30:47 josejx Exp $

WANT_ANT_TASKS="ant-nodeps"
JAVA_PKG_IUSE="doc examples source"

inherit versionator java-pkg-2 java-ant-2

DESCRIPTION="The JavaHelp system online help system"
HOMEPAGE="https://javahelp.dev.java.net/"

MY_PV="${PV/_p/_svn}"
MY_PN="${PN}2"
SRC_URI="https://${PN}.dev.java.net/files/documents/5985/47404/${MY_PN}-src-${MY_PV}.zip"

LICENSE="GPL-2-with-linking-exception"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

COMMON_DEP="
	=dev-java/servletapi-2.4*"
RDEPEND="
	>=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND="
	>=virtual/jdk-1.4
	app-arch/unzip
	${COMMON_DEP}
	"

S="${WORKDIR}/${MY_PN}-${MY_PV}/"
BDIR="${S}/javahelp_nbproject"

src_unpack() {
	unpack "${A}"
	# jdic does not currently build out of the box against the browsers we have
	cd "${S}/jhMaster/JavaHelp/src/new/" || die
	rm -v javax/help/plaf/basic/BasicNativeContentViewerUI.java || die
	cd "${BDIR}/lib" || die
	java-pkg_jar-from servletapi-2.4
}

_eant() {
	cd ${BDIR} || die
	eant \
		-Dservlet-jar="$(java-pkg_getjar servletapi-2.4 servlet-api.jar)" \
		-Djsp-jar="$(java-pkg_getjar servletapi-2.4 jsp-api.jar)" \
		-Djdic-jar-present=true \
		-Djdic-zip-present=true \
		-Dtomcat-zip-present=true \
		-Dservlet-jar-present=true \
		${@}
}

src_compile() {
	_eant release $(use_doc)
}

#Does not actually run anything
#src_test() {
#	_eant test
#}

src_install() {
	cd jhMaster/JavaHelp || die
	dodoc README || die
	dohtml *.{html,css} || die
	java-pkg_dojar "${BDIR}"/dist/lib/*.jar
	java-pkg_dolauncher jhsearch \
		--main com.sun.java.help.search.QueryEngine
	java-pkg_dolauncher jhindexer \
		--main com.sun.java.help.search.Indexer
	use doc && java-pkg_dojavadoc "${BDIR}/dist/lib/javadoc"
	cd "${S}"
	use source && java-pkg_dosrc \
		./jhMaster/JSearch/*/com \
		./jhMaster/JavaHelp/src/*/{javax,com}
	use examples && java-pkg_doexamples jhMaster/JavaHelp/demos
}

pkg_postinst() {
	elog "Native browser integration is disabled because it needs jdic"
	elog "which does not build out of the box. See"
	elog "https://bugs.gentoo.org/show_bug.cgi?id=53897 for progress"
}
