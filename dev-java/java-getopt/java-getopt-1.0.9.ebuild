# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/java-getopt/java-getopt-1.0.9.ebuild,v 1.6 2004/06/24 22:31:08 agriffis Exp $

DESCRIPTION="Java command line option parser"
HOMEPAGE="http://www.urbanophile.com/arenn/hacking/download.html"
SRC_URI="ftp://ftp.urbanophile.com/pub/arenn/software/sources/java-getopt-${PV}.tar.gz"
S=${WORKDIR}
LICENSE="LGPL-2.1"
SLOT="1"
DEPEND=">=virtual/jdk-1.2
	>=dev-java/ant-1.4.1"
KEYWORDS="x86 ~ppc"
IUSE=""

src_unpack() {
	unpack ${P}.tar.gz
}

src_compile() {
	mv gnu/getopt/buildx.xml build.xml
	ant all
}

src_install () {
	dojar build/lib/gnu.getopt.jar
	dohtml build/api/* -r
	dodoc gnu/getopt/COPYING.LIB gnu/getopt/ChangeLog gnu/getopt/README
}
