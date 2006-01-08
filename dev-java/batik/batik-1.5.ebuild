# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/batik/batik-1.5.ebuild,v 1.15 2006/01/08 11:33:31 betelgeuse Exp $

inherit java-pkg

DESCRIPTION="Batik is a Java(tm) technology based toolkit for applications or applets that want to use images in the Scalable Vector Graphics (SVG) format for various purposes, such as viewing, generation or manipulation."
SRC_URI="mirror://apache/xml/batik/${PN}-src-${PV}.zip"
HOMEPAGE="http://xml.apache.org/batik/"
IUSE="doc"
LICENSE="Apache-1.1"
SLOT="1.5"
KEYWORDS="~amd64 ~ppc ~sparc x86"

RDEPEND=">=virtual/jre-1.3
	=dev-java/rhino-1.5*
	>=dev-java/xerces-2.6
	dev-java/xml-commons"
DEPEND=">=virtual/jdk-1.3
	${RDEPEND}
	app-arch/unzip
	dev-java/ant-core"

S=${WORKDIR}/xml-batik

src_unpack() {
	jar xf ${DISTDIR}/${PN}-src-${PV}.zip
	cd ${S}/lib
	rm -f *.jar
	java-pkg_jar-from xerces-2
	java-pkg_jar-from rhino-1.5
}

src_compile() {
	export ANT_OPTS=-Xmx256m
	local antflags="jars all-jar"
	ant ${antflags} || die "compile problem"
}

src_install() {
	java-pkg_dojar ${P}/batik*.jar

	cd ${P}/lib
	rm {js,x*}.jar

	# needed because batik expects this layout:
	# batik.jar lib/*.jar
	# there are hardcoded classpathes in the manifest :(
	for jar in *.jar
	do
		java-pkg_dojar ${jar}
		rm -f ${jar}
		ln -s ${DESTTREE}/share/${PN}-${SLOT}/lib/${jar} ${jar}
	done

	cd ${S}
	cp -ra ${P}/lib ${D}${DESTTREE}/share/${PN}-${SLOT}/lib/

	dodoc README LICENSE
	use doc && java-pkg_dohtml -r ${P}/docs/

	echo "#!/bin/sh" > ${PN}${SLOT}
	echo '${JAVA_HOME}/bin/java -classpath $(java-config -p batik-1.5,xerces-2,rhino-1.5) org.apache.batik.apps.svgbrowser.Main $*' >> ${PN}${SLOT}
	dobin ${PN}${SLOT}

}
