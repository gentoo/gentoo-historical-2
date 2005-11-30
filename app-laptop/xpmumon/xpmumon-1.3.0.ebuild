# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-laptop/xpmumon/xpmumon-1.3.0.ebuild,v 1.1.1.1 2005/11/30 10:05:39 chriswhite Exp $

DESCRIPTION="Battery monitor for PMU-based Powerbooks and iBooks"
HOMEPAGE="http://packages.debian.org/unstable/x11/xpmumon"
SRC_URI="http://ftp.debian.org/debian/pool/main/x/xpmumon/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc"
IUSE=""

DEPEND="virtual/x11"

src_compile() {
	xmkmf -a
	make || die "compile failed"
}

src_install() {
	make install install.man DESTDIR=${D} || die
}

