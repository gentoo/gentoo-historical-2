# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/sun-jimi/sun-jimi-1.0.ebuild,v 1.1 2004/12/23 12:14:06 karltk Exp $

inherit java-pkg

DESCRIPTION="Jimi is a class library for managing images."
HOMEPAGE="http://java.sun.com/products/jimi/"
SRC_URI="jimi1_0.zip"
LICENSE="sun-bcla-jimi"
SLOT="0"
KEYWORDS="x86 ~sparc ~ppc amd64"
IUSE="doc"
DEPEND="virtual/jre
		app-arch/unzip"
RESTRICT="fetch"

S=${WORKDIR}/Jimi

DOWNLOAD_URL="http://javashoplm.sun.com/ECom/docs/Welcome.jsp?StoreId=22&PartDetailId=7259-jimi_sdk-1.0-oth-JPR&SiteId=JSC&TransactionId=noreg"

pkg_nofetch() {
	einfo "Please download ${A} from the following url and place it in ${DISTDIR}"
	einfo "${DOWNLOAD_URL} "
}

src_unpack() {
	unpack ${A}
	cd ${S}
	rm -rf src/classes/*
}

src_compile() {
	cd ${S}/src
	javac -target 1.2 -classpath . -d classes $(cat main_classes.txt) || die "failes to	compile"
	jar -cf ${PN}.jar -C classes . || die "failed to create jar"
}

src_install() {
	java-pkg_dojar src/${PN}.jar

	dodoc Readme License
	use doc && java-pkg_dohtml -r docs/*
}
