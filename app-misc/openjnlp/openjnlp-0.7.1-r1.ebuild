# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/openjnlp/openjnlp-0.7.1-r1.ebuild,v 1.3 2004/11/03 11:57:25 axxo Exp $

inherit java-pkg

DESCRIPTION="An open-source implementation of the JNLP"
HOMEPAGE="http://openjnlp.nanode.org/"
SRC_URI="mirror://sourceforge/openjnlp/OpenJNLP-src-rel_ver-${PV//./-}.zip"
LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND="virtual/jdk
	app-arch/unzip
	>=dev-java/ant-1.6
	dev-java/sax
	dev-java/jnlp-bin
	dev-java/nanoxml"
RDEPEND="virtual/jre"

S=${WORKDIR}/OpenJNLP-src-rel_ver-${PV//./-}

src_unpack() {
	unpack ${A}
	cd ${S}/jars
	java-pkg_jar-from jnlp-bin
	java-pkg_jar-from sax
	java-pkg_jar-from nanoxml nanoxml.jar nanoxml-2.2.jar
	java-pkg_jar-from nanoxml nanoxml-sax.jar nanoxml-sax-2.2.jar
}

src_compile() {
	cd ${S}/targets
	ant build -lib ../jars/MRJToolkitStubs.zip || die "failed to build"
}

src_install() {
	cd ${S}/build/apps/unix/OpenJNLP-0.7.1/
	java-pkg_dojar lib/*.jar

	echo "#!/bin/sh" > ${PN}
	echo "\${JAVA_HOME}/bin/java -cp \$(java-config --classpath=openjnlp) org.nanode.app.OpenJNLP \$*" >> ${PN}

	dodoc {History,ReadMe}.txt

	dobin ${PN}
}

