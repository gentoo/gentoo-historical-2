# Copyright 2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-collections/commons-collections-2.1-r1.ebuild,v 1.5 2002/12/15 16:19:49 strider Exp $

S=${WORKDIR}/${PN}-${PV}-src
DESCRIPTION="Jakarta-Commons Collections Component"
HOMEPAGE="http://jakarta.apache.org/commons/collections.html"
SRC_URI="http://jakarta.apache.org/builds/jakarta-commons/release/${PN}/v${PV}/${PN}-${PV}-src.tar.gz"
DEPEND=">=virtual/jdk-1.3
		>=ant-1.4
		junit? ( >=dev-java/junit-3.7 )"
RDEPEND=">=virtual/jre-1.3"
LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="x86"
IUSE="jikes junit"

src_compile() {
	local myc

	if [ -n "`use jikes`" ] ; then
		myc="${myc} -Dbuild.compiler=jikes"
	fi

	if [ -n "`use junit`" ] ; then
		echo "junit.jar=`java-config --classpath=junit`" > build.properties
		ANT_OPTS=${myc} ant || die "Testing Classes Failed"
	fi

	ANT_OPTS=${myc} ant dist-jar || die "Compilation Failed"
	ANT_OPTS=${myc} ant doc || die "Unable to create documents"
}

src_install () {
	dojar dist/${PN}*.jar || die "Unable to Install"
	dohtml dist/*.html
	dohtml -r dist/docs/*
}
