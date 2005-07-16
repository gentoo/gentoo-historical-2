# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/jcvs/jcvs-5.4.2.ebuild,v 1.6 2005/07/16 19:05:04 axxo Exp $

inherit java-pkg

DESCRIPTION="Java CVS client"
HOMEPAGE="http://www.jcvs.org/"
SRC_URI="http://www.jcvs.org/download/jcvs/jcvsii-${PV}.zip"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86 ppc amd64"
IUSE="doc jikes"
RDEPEND=">=virtual/jre-1.3
	>=dev-java/sun-jaf-bin-1.0.2
	>=dev-java/commons-logging-1.0.4
	>=dev-java/j2ssh-0.2.7
	>=dev-java/javahelp-bin-2"
DEPEND=">=virtual/jdk-1.3
	${RDEPEND}
	dev-java/ant-core
	app-arch/unzip
	jikes? ( dev-java/jikes )"

S="${WORKDIR}/jCVS-${PV}"

src_unpack() {
	unpack ${A}
	cd ${S}/bin
	rm -f *.jar jars/*.jar
	cd jars
	java-pkg_jar-from sun-jaf-bin activation.jar
	java-pkg_jar-from commons-logging commons-logging.jar
	java-pkg_jar-from j2ssh j2ssh-common.jar
	java-pkg_jar-from j2ssh j2ssh-core.jar
	java-pkg_jar-from javahelp-bin jh.jar

	cd ${S}
	cp ${FILESDIR}/build.xml .
	cp ${FILESDIR}/MANIFEST.MF .
}

src_compile() {
	# not possible to compile the source code with jikes.
	ant jar || die "failed to build"
}

src_install() {
	java-pkg_dojar bin/jcvsii.jar

	echo "#!/bin/sh" > ${PN}
	echo "java -cp \$(java-config -p commons-logging,jcvs,sun-jaf-bin,j2ssh,javahelp-bin) com.ice.jcvsii.JCVS" >> ${PN}
	dobin ${PN}

	use doc && java-pkg_dohtml -r doc/api/*
	dodoc doc/lgpl.html doc/license.html doc/relnotes/*
}
