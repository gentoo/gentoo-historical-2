# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/fop/fop-0.20.5.ebuild,v 1.1 2004/02/25 18:16:55 absinthe Exp $

inherit java-pkg

IUSE="doc"

MY_V=${PV/_/}
DESCRIPTION="Formatting Objects Processor is a print formatter driven by XSL"
SRC_URI="mirror://apache/xml/fop/fop-${MY_V}-src.tar.gz"
HOMEPAGE="http://xml.apache.org/fop/"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND=">=virtual/jdk-1.4
		>=dev-java/ant-1.5.4
		!dev-java/fop-bin"

S=${WORKDIR}/${P/_/}

src_unpack() {
		unpack ${A}
}

src_compile() {
		ant package || die "Failed building classes"

		if [ -n "`use doc`" ]; then
			ant javadocs || die "Failed building javadocs"
		fi
}

src_install () {
		sed '2itest "$FOP_HOME" || FOP_HOME=/usr/share/fop/' fop.sh > fop
		java-pkg_dojar build/*.jar
		java-pkg_dojar lib/*.jar

		exeinto /usr/bin
		doexe fop

		if [ -n "`use doc`" ]; then
			dodoc CHANGES STATUS README LICENSE
			dohtml ReleaseNotes.html
			dodir /usr/share/doc/${P}
	        cp -a examples ${D}/usr/share/doc/${P}
	        dohtml -r build/javadocs
		fi
}
