# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/avalon-phoenix/avalon-phoenix-4.0.4.ebuild,v 1.14 2005/04/22 08:15:33 blubb Exp $

inherit java-pkg

MY_P=phoenix-${PV}
DESCRIPTION="Avalon Phoenix is a API for java-based servers"
HOMEPAGE="http://avalon.apache.org"
SRC_URI="mirror://apache/avalon/phoenix/v${PV}/${MY_P}-src.tar.gz"
LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="x86 ~sparc amd64"
DEPEND=">=virtual/jdk-1.4
	>=dev-java/ant-1.5.2
	jikes? ( dev-java/jikes )"
RDEPEND=">=virtual/jre-1.3"
IUSE="jikes debug"

S=${WORKDIR}/${MY_P}

src_compile() {
	if use jikes
	then
		echo "build.compiler=jikes\n" > ${S}/.ant.properties
	fi
	if use debug
	then
		echo "build.debug=on\n" >> ${S}/.ant.properties
	else
		echo "build.debug=off\n" >> ${S}/.ant.properties
	fi
	echo "build.deprecation=off\nbuild.optimize=on" >> ${S}/.ant.properties
	echo 'tools.jar=${java.home}/../j2sdk1.3/lib/tools.jar' >> ${S}/.ant.properties
	echo "phoenix.home=phoenix-home" >> ${S}/.ant.properties
	echo "base.path=/opt" >> ${S}/.ant.properties 	#Is this really needed?

	ant get-mx4j main || die "failed to build"
}

src_install() {
	java-pkg_dojar dist/bin/lib/*.jar
	java-pkg_dojar dist/bin/phoenix-loader.jar
	dodoc README.txt LICENSE.txt
	dodir /usr/share/doc/
	java-pkg_dohtml -A .css .jpg .gif -r docs
}
