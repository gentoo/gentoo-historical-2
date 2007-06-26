# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/projectx/projectx-0.90.4.00-r2.ebuild,v 1.5 2007/06/26 02:18:18 mr_bones_ Exp $

inherit eutils java-pkg-2 java-ant-2

MY_PN="ProjectX"

# micro-release == 0 ?
if [ 0${PV##*.} -eq 0 ]; then
	MY_P="${MY_PN}_Source_${PV%.*}"
else
	MY_P="${MY_PN}_Source_${PV}"
fi

DESCRIPTION="Converts, splits and demuxes DVB and other MPEG recordings"
HOMEPAGE="http://sourceforge.net/projects/project-x/"
SRC_URI="mirror://sourceforge/project-x/${MY_PN}_Source_eng_${PV}.zip
	mirror://sourceforge/project-x/${MY_PN}_LanguagePack_${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="X doc source"

COMMON_DEP="dev-java/commons-net
	=dev-java/jakarta-oro-2.0*"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"

DEPEND=">=virtual/jdk-1.4
	${COMMON_DEP}
	app-arch/unzip
	dev-java/ant-core
	source? ( app-arch/zip )"

S="${WORKDIR}/${MY_P}"

mainclass() {
	# read Main-Class from MANIFEST.MF
	sed -n "s/^Main-Class: \([^ ]\+\).*/\1/p" "${S}/MANIFEST.MF"
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# copy build.xml
	cp -f "${FILESDIR}/build-${PV%.*}.xml" build.xml

	# patch location of executable
	sed -i -e "s:^\(Exec=\).*:\1${PN}:g" *.desktop

	# convert CRLF to LF
	edos2unix *.txt MANIFEST.MF

	# update library packages
	cd lib
	rm -f {commons-net,jakarta-oro}*.jar
	java-pkg_jar-from commons-net
	java-pkg_jar-from jakarta-oro-2.0
	java-pkg_ensure-no-bundled-jars
}

src_compile() {
	eant build $(use_doc) -Dmanifest.mainclass=$(mainclass)
}

src_install() {
	java-pkg_dojar dist/${PN}.jar

	java-pkg_dolauncher ${PN}_nogui --main $(mainclass) \
		--java_args "-Djava.awt.headless=true"

	if use X; then
		java-pkg_dolauncher ${PN}_gui --main $(mainclass)
		dosym ${PN}_gui /usr/bin/${PN}
		domenu *.desktop
	else
		dosym ${PN}_nogui /usr/bin/${PN}
	fi

	dodoc *.txt
	use doc && java-pkg_dojavadoc apidocs
	use source && java-pkg_dosrc src
}
