# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/projectx/projectx-0.81.7.ebuild,v 1.6 2005/01/07 21:16:59 luckyduck Exp $

inherit java-pkg

MY_PN=ProjectX

DESCRIPTION="Converts, splits and demuxes DVB and other MPEG recordings"
HOMEPAGE="http://www.lucike.info/"
SRC_URI="http://www.lucike.info/download/software/projectx/${MY_PN}_Source_${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~amd64"
IUSE=""
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	>=dev-java/ant-1.4.1"
RDEPEND=">=virtual/jre-1.4"

S="${WORKDIR}/${MY_PN}_Source"

src_unpack() {
	unpack "${A}"
	cd ${S}
	# fix html help location
	sed -i "s|htmls/index.html|/usr/share/doc/${P}/html/index.html|g" src/Html.java
	# copy selfmade ant build.xml
	cp "${FILESDIR}/build.xml" .
}

src_compile() {
	local antflags="dist -DJARNAME=${P}"
	ant ${antflags} || die "compile problem"
}

src_install() {
	# create shellscript wrapper
	echo -e "#!/bin/sh\nexec \${JAVA_HOME}/bin/java -jar /usr/share/${PN}/${P}.jar \"\$@\"" > ${MY_PN}

	insinto "/usr/share/${PN}"
	doins dist/lib/*.jar ac3.bin

	dodoc Copying *.txt

	java-pkg_dohtml -r htmls/
	dobin ${MY_PN}
}

