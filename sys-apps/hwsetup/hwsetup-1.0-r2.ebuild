# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/hwsetup/hwsetup-1.0-r2.ebuild,v 1.7 2005/06/22 14:05:06 wolf31o2 Exp $

inherit eutils

MY_PV=${PV}-14
DESCRIPTION="Hardware setup program"
HOMEPAGE="http://www.knopper.net/"
SRC_URI="http://developer.linuxtag.net/knoppix/sources/${PN}_${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 -mips ppc ppc64 ~sparc x86"
IUSE=""

DEPEND="|| (
	sys-apps/kudzu-knoppix
	sys-apps/kudzu )"
RDEPEND="virtual/libc"

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${P}-gentoo.patch
}

src_compile() {
	emake  || die
}

src_install() {
	einstall DESTDIR=${D} PREFIX=/usr MANDIR=/usr/share/man || die "Install failed"
}
