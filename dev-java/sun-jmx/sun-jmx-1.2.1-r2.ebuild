# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/sun-jmx/sun-jmx-1.2.1-r2.ebuild,v 1.1 2006/07/21 03:15:22 nichoj Exp $

inherit java-pkg-2 eutils

MY_PN=${PN//sun-/}
MY_P=${MY_PN}-${PV//./_}
DESCRIPTION="Java Management Extensions for managing and monitoring devices, applications, and services."
HOMEPAGE="http://java.sun.com/products/JavaManagement/index.jsp"
SRC_URI="${MY_P}-scsl.zip"
LICENSE="sun-csl"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64 ~sparc ~ppc64"
IUSE="doc examples source"
DEPEND=">=virtual/jdk-1.4
	dev-java/ant-core
	app-arch/unzip
	source? ( app-arch/zip )"
RDEPEND=">=virtual/jre-1.4"
RESTRICT="fetch"

S="${WORKDIR}/${MY_P}-src"

DOWNLOADSITE="http://wwws.sun.com/software/communitysource/jmx/download.html"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i.orig -r -e 's/="src"/="src\/jmxri"/g' build.xml || die "sed failed"
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
	eant jar $(use_doc examples)
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
