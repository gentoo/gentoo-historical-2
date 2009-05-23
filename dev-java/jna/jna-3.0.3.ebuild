# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jna/jna-3.0.3.ebuild,v 1.1 2009/05/23 07:41:07 caster Exp $

EAPI=2

JAVA_PKG_IUSE="test doc source"
WANT_ANT_TASKS="ant-nodeps"

inherit java-pkg-2 java-ant-2 toolchain-funcs

DESCRIPTION="Java Native Access (JNA)"
HOMEPAGE="https://jna.dev.java.net/"
# repack and mirror
#SRC_URI="http://jna.dev.java.net/source/browse/*checkout*/jna/tags/${PV}/jnalib/dist/src.zip"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sys-devel/gcc-4.3[libffi]
	>=virtual/jre-1.4"

DEPEND=">=sys-devel/gcc-4.3
	!test? ( >=virtual/jdk-1.4 )
	test? (
		dev-java/ant-junit
		dev-java/ant-trax
		>=virtual/jdk-1.5
	)"

JAVA_ANT_REWRITE_CLASSPATH="true"

pkg_setup() {
	if (( `gcc-major-version` < 4 )) || (( `gcc-minor-version` < 3 )) ; then
		eerror "gcc 4.3 or greater is needed to build and run this. You seem to have a"
		eerror "sufficient version installed but you need to select it with gcc-config."
		die "gcc 4.3 or greater must be selected"
	fi
}

java_prepare() {
	# Fetch our own prebuilt libffi.
	mkdir -p build/native/libffi/.libs || die
	ln -snf "${ROOT}`_gcc-install-dir`/libffi.so" build/native/libffi/.libs/libffi_convenience.a || die

	# Build to same directory on 64-bit archs.
	ln -snf build build-d64 || die
}

src_install() {
	java-pkg_dojar build/${PN}.jar
	java-pkg_doso build/native/libjnidispatch.so
	use source && java-pkg_dosrc src/com
	use doc && java-pkg_dojavadoc doc/javadoc
}

src_test() {
	ANT_TASKS="ant-junit ant-nodeps ant-trax" eant test
}
