# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/bytelist/bytelist-1.0.ebuild,v 1.2 2009/01/05 22:01:39 maekke Exp $

JAVA_PKG_IUSE="source test"
inherit java-pkg-2 java-ant-2

DESCRIPTION="JRuby support library"
HOMEPAGE="http://jruby.codehaus.org/"
SRC_URI="http://dev.gentooexperimental.org/~chewi/distfiles/${P}.tar.bz2"
LICENSE="|| ( CPL-1.0 GPL-2 LGPL-2.1 )"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=virtual/jre-1.4"

DEPEND=">=virtual/jdk-1.4
	test? ( dev-java/ant-junit )"

JAVA_ANT_REWRITE_CLASSPATH="true"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Don't do tests unnecessarily.
	sed -i 's:depends="test":depends="compile":' build.xml
}

src_install() {
	java-pkg_newjar lib/bytelist-0.1.jar
	use source && java-pkg_dosrc src/*
}

src_test() {
	ANT_TASKS="ant-junit" eant test
}
