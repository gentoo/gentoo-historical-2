# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/guava/guava-07.ebuild,v 1.1 2011/11/09 19:17:24 sera Exp $

EAPI="4"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_P="${PN}-r${PV}"
DESCRIPTION="A collection of Google's core Java libraries"
HOMEPAGE="http://code.google.com/p/guava-libraries/"
SRC_URI="http://guava-libraries.googlecode.com/files/${MY_P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEP="
	dev-java/jsr305:0
	java-virtuals/jdk-with-com-sun:0"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.5"
DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.5
	app-arch/unzip"

S="${WORKDIR}/${MY_P}"
JAVA_GENTOO_CLASSPATH="jsr305"

java_prepare() {
	unpack ./${PN}-src-r${PV}.zip
}

src_install() {
	java-pkg-simple_src_install
	dodoc README
}
