# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/saxpath/saxpath-1.0.ebuild,v 1.7 2005/07/09 16:07:45 axxo Exp $

inherit java-pkg

DESCRIPTION="A Simple API for XPath."
HOMEPAGE="http://saxpath.sourceforge.net/"
SRC_URI="mirror://sourceforge/saxpath/${P}.tar.gz"
LICENSE="saxpath"
SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 ~sparc x86"
IUSE="doc junit source"

RDEPEND=">=virtual/jre-1.4
	dev-java/xalan
	>=dev-java/xerces-2.6.2-r1"
DEPEND=">=virtual/jdk-1.4
	dev-java/ant
	junit? ( dev-java/junit )
	${RDEPEND}"

S=${WORKDIR}/${P}-FCS

src_unpack() {
	unpack ${A}
	cd ${S}
	rm -f *.jar
	mkdir src/conf
	cp ${FILESDIR}/MANIFEST.MF src/conf
	cd lib
	rm -f *.jar
	use junit && java-pkg_jar-from junit
	java-pkg_jar-from xalan
	java-pkg_jar-from xerces-2
}

src_compile() {
	local antops="package"
	use doc && antops="${antops} doc javadoc"
	use junit && antops="${antops} test"
	ant ${antops} || die "failed to compile"
}

src_install() {
	java-pkg_dojar build/saxpath.jar

	use doc && java-pkg_dohtml -r build/doc/*
	use source && java-pkg_dosrc src/java/main/*
}
