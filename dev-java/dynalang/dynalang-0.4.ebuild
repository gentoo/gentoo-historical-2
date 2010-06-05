# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/dynalang/dynalang-0.4.ebuild,v 1.2 2010/06/05 08:36:33 ali_bush Exp $

EAPI=3

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

MY_P="${PN}-mop-${PV}"

DESCRIPTION="Library for implementation of interoperable metaobject protocols for dynamic languages."
HOMEPAGE="http://sourceforge.net/projects/dynalang/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${MY_P}.tgz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5
	test? (
		dev-java/emma:0
		dev-java/junit:0
		dev-java/ant-junit:0
	)"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	find . -iname '*.jar' -delete

	sed -i -e '/ivy:retrieve/d' build.xml || die

	sed -i -e \
		's/clazz.getConstructors/(Constructor<T>[])clazz.getConstructors/' \
		src/org/dynalang/mop/beans/BeanMetaobjectProtocol.java || die

	mkdir -p build/lib/test
}

EANT_DOC_TARGET="doc"

src_test() {
	java-pkg_jar-from --into build/lib/test emma,junit

	ANT_TASKS="ant-junit" eant test
}

src_install() {
	java-pkg_newjar "build/${MY_P}.jar"
	use doc && java-pkg_dojavadoc build/doc/javadoc
	use source && java-pkg_dosrc src/*
}
