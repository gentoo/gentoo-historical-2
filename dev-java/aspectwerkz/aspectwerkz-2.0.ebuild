# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/aspectwerkz/aspectwerkz-2.0.ebuild,v 1.1 2007/12/25 01:57:33 betelgeuse Exp $

# Add java5 support when java-config handless
# https://bugs.gentoo.org/show_bug.cgi?id=161622
# for now the support is in java-overlay
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="AspectWerkz is a dynamic, lightweight and high-performant AOP/AOSD framework for Java."
SRC_URI="http://dist.codehaus.org/${PN}/distributions/${P}.zip"
HOMEPAGE="http://aspectwerkz.codehaus.org"
LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE="java5"

COMMON_DEP="
	=dev-java/asm-1.5*
	dev-java/bcel
	dev-java/concurrent-util
	=dev-java/dom4j-1*
	=dev-java/javassist-2*
	dev-java/jrexx
	>=dev-java/junitperf-1.9.1
	dev-java/trove
	dev-java/qdox
	=dev-java/junit-3*"
RDEPEND="
	java5? ( >=virtual/jre-1.5 )
	!java5? ( >=virtual/jre-1.4 )
	${COMMON_DEP}"
DEPEND="
	java5? ( >=virtual/jdk-1.5 )
	!java5? ( >=virtual/jdk-1.4 )
	${COMMON_DEP}
	app-arch/unzip"

src_unpack() {
	unpack ${A}

	cd "${S}"
	# unit tests need this
	chmod +x bin/${PN} || die
	epatch ${FILESDIR}/${P}-gentoo.patch

	find . -name '*.jar' -exec rm {} \; || die

	cd "${S}/lib"
	java-pkg_jar-from asm-1.5
	java-pkg_jar-from bcel
	java-pkg_jar-from concurrent-util
	java-pkg_jar-from dom4j-1
	java-pkg_jar-from javassist-2
	java-pkg_jar-from jrexx
	java-pkg_jar-from junit
	java-pkg_jar-from junitperf
	java-pkg_jar-from trove
	java-pkg_jar-from qdox-1.6
}

_eant() {
	local version=1.4
	use java5 && version=1.5
	eant ${antflags} -Djava.version=${version} "${@}"
}

src_compile() {
	_eant dist #precompiled javadocs
	rm -v lib/*nodeps*.jar || die
}

src_test() {
	ASPECTWERKZ_HOME="${S}" _eant test
}

src_install() {
	use source && java-pkg_dosrc src/*
	# other stuff besides javadoc here too
	use doc && java-pkg_dohtml -r docs/*

	cd lib
	for jar in ${PN}*.jar; do
		java-pkg_newjar ${jar} ${jar/-${PV}}
	done
}
