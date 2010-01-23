# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/java-getopt/java-getopt-1.0.13.ebuild,v 1.9 2010/01/23 12:17:29 aballier Exp $

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java command line option parser"
HOMEPAGE="http://www.urbanophile.com/arenn/hacking/download.html"
SRC_URI="ftp://ftp.urbanophile.com/pub/arenn/software/sources/${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="1"
DEPEND=">=virtual/jdk-1.4
	dev-java/ant-core"
RDEPEND=">=virtual/jre-1.4"
KEYWORDS="amd64 ~ia64 ppc ppc64 x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="doc source"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	cd "${S}"
	mv gnu/getopt/buildx.xml build.xml || die
}

src_install() {
	java-pkg_dojar build/lib/gnu.getopt.jar
	dodoc gnu/getopt/COPYING.LIB gnu/getopt/ChangeLog gnu/getopt/README || die
	use doc && java-pkg_dojavadoc build/api
	use source && java-pkg_dosrc gnu
}
