# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/nanoxml/nanoxml-2.2.3-r2.ebuild,v 1.3 2007/04/26 12:24:02 opfer Exp $

inherit java-pkg-2 java-ant-2

DESCRIPTION="NanoXML is a small non-validating parser for Java. "

HOMEPAGE="http://nanoxml.sourceforge.net/"
MY_P=NanoXML-${PV}
SRC_URI="http://nanoxml.cyberelf.be/downloads/${MY_P}.tar.gz"
LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE="doc source"
COMMON_DEP="dev-java/sax"
DEPEND="
	!doc? ( >=virtual/jdk-1.4 )
	doc? ( || ( =virtual/jdk-1.4* =virtual/jdk-1.5* ) )
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd ${S}/ThirdParty/SAX
	java-pkg_jar-from sax
	cd ${S}

	local docsed
	if use doc; then
		docsed="javadoc -source $(java-pkg_get-source)"
	else
		docsed="true"
	fi

	# Use the right arguments for javac/javadoc
	sed -e "s:/tmp/:${T}/:g" \
		-e "s/javac/javac $(java-pkg_javac-args)/" \
		-e "s/-target 1.1//" \
		-e "s/javadoc/${docsed}/" \
		-i build.sh || die "failed to sed"
}

src_compile() {
	./build.sh || die "failed to build"
}

src_install() {
	java-pkg_dojar Output/*.jar

	dohtml -r Documentation/NanoXML-*
	use doc && java-pkg_dojavadoc Documentation/JavaDoc
}
