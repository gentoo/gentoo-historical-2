# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/ltmodem/ltmodem-8.22_alpha5.ebuild,v 1.5 2003/02/13 13:53:44 vapier Exp $

MY_P="${P/_alpha/a}"
DESCRIPTION="Winmodems with Lucent Apollo (ISA) and Mars (PCI) chipsets"
HOMEPAGE="http://www.heby.de/ltmodem/"
SRC_URI="http://www.physcip.uni-stuttgart.de/heby/ltmodem/${MY_P}.tar.gz
	http://www.sfu.ca/~cth/ltmodem/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

S="${WORKDIR}/${MY_P}"

src_compile() {
	#the installer has you press 'Enter' a whole lot
	./build_module ${KV} << EOF















EOF
	[ -a drivers-${KV}/lt_modem.o ]  || die "modem.o did not build"
	[ -a drivers-${KV}/lt_serial.o ] || die "serial.o did not build"
}

src_install() {
	dohtml DOCs/*.html
	rm -rf DOCs/*.html DOCs/Installers

	dodoc 1ST-READ BLDrecord.txt Utility_version_tests.txt DOCs/*

	mv utils/fixscript utils/ltfixscript
	mv utils/noisefix utils/ltnoisefix
	mv utils/unloading utils/ltunloading
	dobin utils/lt*

	insinto /lib/modules/${KV}/ltmodem
	newins drivers-${KV}/lt_modem.o lt_modem.o
	newins drivers-${KV}/lt_serial.o lt_serial.o
}

pkg_postinst() {
	einfo "To get going real fast read this doc:"
	einfo "/usr/share/doc/${P}/html/post-install.html"
}
