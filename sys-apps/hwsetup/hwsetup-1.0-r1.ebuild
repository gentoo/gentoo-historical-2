# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/hwsetup/hwsetup-1.0-r1.ebuild,v 1.3 2004/05/30 14:43:25 wolf31o2 Exp $

MY_PV=${PV}-14
DESCRIPTION="Hardware setup program"
SRC_URI="http://developer.linuxtag.net/knoppix/sources/${PN}_${MY_PV}.tar.gz"
HOMEPAGE="http://www.knopper.net"

KEYWORDS="x86 ~amd64 -ppc -sparc ~alpha -mips"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=sys-apps/kudzu-knoppix-1.0"
RDEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}
}

src_compile() {
	emake  || die
}

src_install() {
	einstall DESTDIR=${D} PREFIX=/usr MANDIR=/usr/share/man || die "Install failed"
}
