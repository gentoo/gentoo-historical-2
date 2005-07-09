# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jmx/jmx-1.2.1.ebuild,v 1.18 2005/07/09 20:21:48 axxo Exp $

inherit java-pkg eutils

DESCRIPTION="Java Management Extensions for managing and monitoring devices, applications, and services."
HOMEPAGE="http://java.sun.com/products/JavaManagement/index.jsp"
SRC_URI="${PN}-${PV//./_}-scsl.zip"
LICENSE="sun-csl"
SLOT="0"
KEYWORDS="x86 ppc amd64 sparc ppc64"
IUSE="doc examples jikes source"
DEPEND=">=virtual/jdk-1.4
	dev-java/ant-core
	app-arch/unzip
	jikes? ( dev-java/jikes )
	source? ( app-arch/zip )"
RDEPEND=">=virtual/jre-1.4"
RESTRICT="fetch"

S="${WORKDIR}/${P//./_}-src"

DOWNLOADSITE="http://wwws.sun.com/software/communitysource/jmx/download.html"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i.orig -r -e 's/="src"/="src\/jmxri"/g' build.xml || die "sed failed"
	epatch ${FILESDIR}/build.xml-jdk1.5.patch
}

pkg_nofetch() {
	einfo
	einfo " Due to license restrictions, we cannot fetch the"
	einfo " distributables automagically."
	einfo
	einfo " 1. Visit ${DOWNLOADSITE} and follow instructions"
	einfo " 2. Download ${SRC_URI}"
	einfo " 3. Move file to ${DISTDIR}"
	einfo " 4. Run emerge on this package again to complete"
	einfo
}

src_compile() {
	local antflags="jar"
	use doc && antflags="${antflags} examples"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	ant ${antflags} || die "compile problem"
}

src_install() {
	java-pkg_dojar lib/*.jar
	use doc && java-pkg_dohtml -r docs/*
	if use examples; then
		dodir /usr/share/doc/${PF}/examples
		cp -r examples/* ${D}/usr/share/doc/${PF}/examples
	fi
	use source && java-pkg_dosrc src/jmxri/*
}
