# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmi8k/wmi8k-1.2.ebuild,v 1.2 2004/05/12 07:44:17 aliz Exp $

S=${WORKDIR}/${PN}
DESCRIPTION="Dockapp for (some) Dell laptops that provides fans and temperature monitoring"
SRC_URI="http://dockapps.org/download.php/id/337/${PN}.${PV}.tar.gz http://www.stoffel.net/${PN}.${PV}.tar.gz"
HOMEPAGE="http://www.stoffel.net"
IUSE=""
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

ISUE=""
DEPEND="virtual/x11"

pkg_setup() {
	modprobe i8k &> /dev/null || test -f /proc/i8k || die "Lacking kernel support for i8k"
}

src_compile() {
	cd ${S}/wmi8k
	emake || die
}

src_install () {
	exeinto /usr/bin
	doexe wmi8k/wmi8k
	dodoc README* COPYING INSTALL CHANGES BUGS HINTS TODO
}
