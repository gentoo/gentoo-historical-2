# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmitime/wmitime-0.3.ebuild,v 1.6 2004/03/19 10:04:28 aliz Exp $

inherit eutils

S="${WORKDIR}/${PN}"

DESCRIPTION="Overglorified clock dockapp w/time, date, and internet time"
HOMEPAGE="http://www.neotokyo.org/illusion/"
SRC_URI="http://www.neotokyo.org/illusion/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"

DEPEND="virtual/glibc
	virtual/x11"

src_unpack() {
	unpack ${A} ; cd ${S}
	epatch ${FILESDIR}/makefile.diff
}

src_compile() {
	cd ${S}/wmitime
	make || die "make failed"
}

src_install() {
	cd ${S}/wmitime
	dobin wmitime

	cd ${S}
	dodoc BUGS CHANGES COPYING README
}
