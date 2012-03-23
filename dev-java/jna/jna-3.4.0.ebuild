# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jna/jna-3.4.0.ebuild,v 1.3 2012/03/23 15:27:47 sera Exp $

EAPI="4"

JAVA_PKG_IUSE="test doc source"
WANT_ANT_TASKS="ant-nodeps"

inherit java-pkg-2 java-ant-2 toolchain-funcs flag-o-matic vcs-snapshot

DESCRIPTION="Java Native Access (JNA)"
HOMEPAGE="https://github.com/twall/jna#readme"
SRC_URI="https://github.com/twall/jna/tarball/3.4.0 -> ${P}-src.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="+awt +nio-buffers"

COMMON_DEP="
	virtual/libffi"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.6"
DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.6
	dev-util/pkgconfig
	test? (
		dev-java/junit:0
		dev-java/ant-junit:0
		dev-java/ant-trax:0
	)"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_BUILD_TARGET="jar contrib-jars"

java_prepare() {
	# delete bundled jars and copy of libffi
	find -name "*.jar" -exec rm -v {} + || die
	rm -r native/libffi || die

	# respect CFLAGS, don't inhibit warnings, honour CC
	# fix build.xml file
	epatch "${FILESDIR}/${PV}-makefile-flags.patch" "${FILESDIR}/${PV}-build.xml.patch"

	# Build to same directory on 64-bit archs.
	mkdir build || die
	ln -snf build build-d64 || die

	if ! use awt ; then
		sed -i -E "s/^(CDEFINES=.*)/\1 -DNO_JAWT/g" native/Makefile || die
	fi

	if ! use nio-buffers ; then
		sed -i -E "s/^(CDEFINES=.*)/\1 -DNO_NIO_BUFFERS/g" native/Makefile || die
	fi
}

EANT_EXTRA_ARGS="-Ddynlink.native=true"

src_install() {
	java-pkg_dojar build/${PN}.jar
	java-pkg_dojar contrib/platform/dist/platform.jar
	java-pkg_doso build/native/libjnidispatch.so
	use source && java-pkg_dosrc src/com
	use doc && java-pkg_dojavadoc doc/javadoc
}

src_test() {
	unset DISPLAY

	mkdir -p lib
	java-pkg_jar-from --into lib --build-only junit

	ANT_TASKS="ant-junit ant-nodeps ant-trax" \
		ANT_OPTS="-Djava.awt.headless=true" eant \
		${EANT_EXTRA_ARGS} test
}
