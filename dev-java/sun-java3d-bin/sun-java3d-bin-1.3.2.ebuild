# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/sun-java3d-bin/sun-java3d-bin-1.3.2.ebuild,v 1.1 2005/04/04 16:32:40 luckyduck Exp $

inherit java-pkg

DESCRIPTION="Sun Java3D API Core"
HOMEPAGE="https://j3d-core.dev.java.net/"
SRC_URI="java3d-${PV//./_}-linux-${ARCH/x86/i586}.zip"
KEYWORDS="~amd64 ~x86 -*"
SLOT="0"
LICENSE="sun-jrl sun-jdl"
IUSE=""
DEPEND="app-arch/unzip"
RDEPEND=">=virtual/jdk-1.3"
RESTRICT="fetch"

S=${WORKDIR}/${A/.zip/}

pkg_nofetch() {
	einfo "Please download ${SRC_URI} from"
	einfo "${HOMEPAGE} and place it in ${DISTDIR}"
}

src_unpack() {
	unpack ${A}
	cd ${S}
	unzip -q j3d-132-linux-${ARCH}.zip
}

src_compile() { :; }

src_install() {
	dodoc COPYRIGHT.txt README.txt

	java-pkg_dojar lib/ext/*.jar
	java-pkg_doso lib/${ARCH/x86/i386}/*.so
}

pkg_postinst() {
	einfo "This ebuild installs into /opt/${PN} and /usr/share/${PN}"
	einfo 'To use you need to pass the following to java'
	einfo '-Djava.library.path=$(java-config -i sun-java3d-bin) -cp $(java-config -p sun-java3d-bin)'
}
