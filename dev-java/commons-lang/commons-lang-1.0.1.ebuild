# Copyright 2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-lang/commons-lang-1.0.1.ebuild,v 1.1 2002/12/02 23:10:39 strider Exp $

S="${WORKDIR}/${PN}-${PV}-src"
DESCRIPTION="Jakarta components to manipulate core java classes"
HOMEPAGE="http://jakarta.apache.org/commons/lang.html"
SRC_URI="http://jakarta.apache.org/builds/jakarta-commons/release/${PN}/v${PV}/${PN}-${PV}-src.tar.gz"
DEPEND=">=virtual/jdk-1.3
	>=dev-java/ant-1.4
	junit? ( >=junit-3.7 )"
RDEPEND=">=virtual/jre-1.3"
LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~x86"
IUSE="jikes junit"

src_compile() {
	local myc

	cp lang/LICENSE.txt LICENSE
	cd lang

	if [ -n "`use jikes`" ] ; then
		myc="${myc} -Dbuild.compiler=jikes"
	fi

	if [ -n "`use junit`" ] ; then
		echo "junit.jar=`java-config --classpath=junit`" | sed s/:.*// > build.properties
		ANT_OPTS=${myc} ant test || die "Testing Classes Failed"
	fi

	ANT_OPTS=${myc} ant jar || die "Compilation Failed"
	ANT_OPTS=${myc} ant javadoc || die "Building Documents Failed"
}

src_install () {
	cd lang
	dodoc RELEASE-NOTES.txt
	mv dist/${PN}-${PV}.jar dist/${PN}.jar
	dojar dist/${PN}.jar || die "Unable to install"
	dohtml -r dist/docs/*
	dohtml PROPOSAL.html STATUS.html
}
