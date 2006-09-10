# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jisp/jisp-2.5.1-r2.ebuild,v 1.2 2006/09/10 15:18:28 nelchael Exp $

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="Java Indexed Serialization Package: A small, embedded database engine written in Pure Java"
HOMEPAGE="http://www.coyotegulch.com/products/jisp/"

# TODO contact upstream about hosting jisp-2.5 on their site.
# They only maintain 3.0 at the moment
# This tarball is from jpackage's jisp2 source rpm
SRC_URI="http://gentooexperimental.org/distfiles/${P}-source.tar.gz"

LICENSE="SVFL"
SLOT="2.5"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc"

DEPEND=">=virtual/jdk-1.4
	dev-java/ant-core"
RDEPEND=">=virtual/jre-1.4"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/${P}-java15.patch

	mkdir src
	mv com src
	cp ${FILESDIR}/build-${PV}.xml build.xml
}

src_compile() {
	eant jar -Dproject.name=${PN} $(use_doc)
}

src_install() {
	java-pkg_dojar dist/${PN}.jar

	use doc && java-pkg_dohtml -r dist/doc/api
}
