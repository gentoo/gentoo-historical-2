# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/bytelist/bytelist-1.0.2.ebuild,v 1.3 2009/07/05 20:36:05 maekke Exp $

EAPI=2
JAVA_PKG_IUSE="source test"
inherit java-pkg-2 java-ant-2

DESCRIPTION="JRuby support library"
HOMEPAGE="http://jruby.codehaus.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
LICENSE="|| ( CPL-1.0 GPL-2 LGPL-2.1 )"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=virtual/jre-1.4
	dev-java/jcodings"

DEPEND=">=virtual/jdk-1.4
	dev-java/jcodings
	test? ( dev-java/ant-junit )"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="jcodings"

java_prepare() {
	# Don't do tests unnecessarily.
	sed -i 's:depends="test":depends="compile":' build.xml
}

src_install() {
	java-pkg_newjar lib/${PN}-1.0.1.jar
	use source && java-pkg_dosrc src/*
}

src_test() {
	ANT_TASKS="ant-junit" eant test
}
