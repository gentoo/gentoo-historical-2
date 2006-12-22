# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/sun-jai-bin/sun-jai-bin-1.1.2.01-r1.ebuild,v 1.5 2006/12/22 23:44:27 caster Exp $

inherit java-pkg

MY_PV=${PV//./_}
DESCRIPTION="JAI is a class library for managing images."
HOMEPAGE="https://jai.dev.java.net/"
SRC_URI="http://download.java.net/media/jai/builds/release/${MY_PV}/jai-${MY_PV}-lib-linux-i586.tar.gz"
LICENSE="sun-bcla-jai"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc x86"
DEPEND="app-arch/unzip"
RDEPEND=">=virtual/jre-1.3"
IUSE=""
RESTRICT="mirror"

S=${WORKDIR}/jai-${MY_PV}/

src_unpack() {
	unpack ${A}
	rm ${S}/LICENSE-jai.txt
}

src_compile() { :; }

src_install() {
	dodoc *.txt

	cd lib
	java-pkg_dojar *.jar
	use x86 && java-pkg_doso *.so
}

pkg_postinst() {
	einfo "This ebuild now installs into /opt/${PN} and /usr/share/${PN}"
	einfo 'To use you need to pass the following to java'
	use x86 && einfo '-Djava.library.path=$(java-config -i sun-jai-bin)'
	einfo '-classpath $(java-config -p sun-jai-bin)'
}

