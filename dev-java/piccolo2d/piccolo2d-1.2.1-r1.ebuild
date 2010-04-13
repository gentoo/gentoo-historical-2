# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/piccolo2d/piccolo2d-1.2.1-r1.ebuild,v 1.2 2010/04/13 14:29:28 phajdan.jr Exp $

EAPI=2
JAVA_PKG_IUSE="doc examples source"

inherit eutils java-pkg-2 java-ant-2

MY_PN="piccolo"
DESCRIPTION="A Structured 2D Graphics Framework"
HOMEPAGE="http://code.google.com/p/piccolo2d/"
SRC_URI="http://piccolo2d.googlecode.com/files/Piccolo2D.Java-${PV}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

COMMON_DEPS="
	dev-java/swt:3
	java-virtuals/jdk-with-com-sun
	"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEPS}"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${COMMON_DEPS}"

S="${WORKDIR}/${MY_PN}-${PV}"

# Needs X11
RESTRICT="test"

java_prepare() {
	find -name '*.jar' -print -delete
	epatch "${FILESDIR}/1.2.1-font-api.patch"
}

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="swt-3,jdk-with-com-sun"
EANT_BUILD_TARGET="${MY_PN} extras"
EANT_GENTOO_CLASSPATH_EXTRA="build/${MY_PN}.jar:build/${MY_PN}x.jar"
EANT_DOC_TARGET="api"
EANT_TEST_TARGET="runtests"

src_install() {
	java-pkg_dojar build/*.jar
	dodoc Readme.txt ReleaseNotes.txt || die
	use doc && java-pkg_dojavadoc doc/api
	use source && java-pkg_dosrc extras/edu src/edu
	use examples && java-pkg_doexamples examples
}
