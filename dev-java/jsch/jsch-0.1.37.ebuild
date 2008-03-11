# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jsch/jsch-0.1.37.ebuild,v 1.4 2008/03/11 15:16:09 ranger Exp $

EAPI=1
JAVA_PKG_IUSE="doc source examples"

inherit java-pkg-2 java-ant-2 java-osgi

DESCRIPTION="JSch is a pure Java implementation of SSH2."
HOMEPAGE="http://www.jcraft.com/jsch/"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ppc ppc64 x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=virtual/jdk-1.4
	dev-java/jzlib:0"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${RDEPEND}"

src_compile() {
	eant -Dproject.cp="$(java-pkg_getjars jzlib)" dist $(use_doc)
}

src_install() {
	java-osgi_newjar dist/lib/jsch*.jar "com.jcraft.jsch" "JSch" \
		"com.jcraft.jsch, com.jcraft.jsch.jce;x-internal:=true, \
com.jcraft.jsch.jcraft;x-internal:=true"

	dodoc README ChangeLog || die
	use doc && java-pkg_dojavadoc javadoc
	use source && java-pkg_dosrc src/*
	use examples && java-pkg_doexamples examples
}
