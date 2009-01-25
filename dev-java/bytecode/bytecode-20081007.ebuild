# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/bytecode/bytecode-20081007.ebuild,v 1.1 2009/01/25 19:32:38 weaver Exp $

EAPI=2

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Biojava bytecode manipulation library"
HOMEPAGE="http://biojava.org"
SRC_URI="http://dev.gentoo.org/~serkan/distfiles/${P}.tar.bz2"
# svn export svn://code.open-bio.org/biojava/bytecode/trunk -r {20081007}
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4"

JAVA_ANT_IGNORE_SYSTEM_CLASSES="true"
EANT_BUILD_TARGET="package"
EANT_DOC_TARGET="javadocs"

src_prepare() {
	mkdir {tests,demos,resources} || die
}

src_install() {
	java-pkg_dojar ant-build/${PN}.jar
	use doc && java-pkg_dojavadoc ant-build/docs
	use source && java-pkg_dosrc src/org
}
