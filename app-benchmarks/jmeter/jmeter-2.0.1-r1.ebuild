# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-benchmarks/jmeter/jmeter-2.0.1-r1.ebuild,v 1.2 2004/09/19 19:32:33 axxo Exp $

inherit java-pkg

DESCRIPTION="Load test and measure performance on HTTP/FTP services and databases."
HOMEPAGE="http://jakarta.apache.org/jmeter"
SRC_URI="mirror://apache/jakarta/jmeter/source/jakarta-${P}_src.tgz"
DEPEND=">=virtual/jdk-1.3
	dev-java/ant
	dev-java/commons-logging
	>=dev-java/commons-httpclient-2.0
	dev-java/commons-collections
	>=dev-java/oro-2.0
	>=dev-java/jdom-1.0_beta9
	>=dev-java/xerces-2.6.2-r1
	dev-java/xalan
	>=dev-java/avalon-logkit-bin-1.2
	dev-java/junit
	dev-java/rhino
	dev-java/soap
	dev-java/jtidy
	doc? ( >=dev-java/velocity-1.4 )"
RDEPEND=">=virtual/jdk-1.3"
LICENSE="Apache-2.0"
SLOT="0"
#bug 63309
KEYWORDS="-*"
IUSE="doc jikes"

S=${WORKDIR}/jakarta-${P}

src_unpack() {
	unpack ${A}
	cd ${S}/lib
	java-pkg_jar-from commons-logging
	java-pkg_jar-from commons-httpclient commons-httpclient.jar commons-httpclient-2.0.jar
	java-pkg_jar-from commons-collections
	java-pkg_jar-from oro oro.jar jakarta-oro-2.0.8.jar
	java-pkg_jar-from jdom jdom.jar jdom-b9.jar
	java-pkg_jar-from xalan
	java-pkg_jar-from xerces-2
	java-pkg_jar-from avalon-logkit-bin avalon-logkit.jar logkit-1.2.jar
	java-pkg_jar-from junit
	java-pkg_jar-from rhino
	java-pkg_jar-from soap
	java-pkg_jar-from jtidy
	rm -f jorphan.jar
}
src_compile () {
	local antflags="package"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	use doc && antflags="${antflags} docs-all"
	use doc && cp /usr/share/velocity/lib/velocity-*.jar $S/lib
	ant ${antflags} || die "compile problem"
}

src_install () {
	DIROPTIONS="--mode=0775"
	dodir /opt/${PN}
	cp -ar bin/ lib/ printable_docs/ ${D}/opt/${PN}/
	dodoc README
	use doc && dohtml -r docs/*
}
