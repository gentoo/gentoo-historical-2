# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmacpi/wmacpi-1.34.ebuild,v 1.8 2004/04/30 22:05:16 pvdabeel Exp $

inherit eutils

IUSE="acpi apm"
DESCRIPTION="WMaker DockApp: ACPI status monitor for laptops"
HOMEPAGE="http://www.ne.jp/asahi/linux/timecop/"
SRC_URI="http://www.ne.jp/asahi/linux/timecop/software/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc amd64 ppc"

DEPEND="virtual/x11"

src_unpack() {
	unpack ${A}
	cd ${S}
	use apm && use acpi && eerror "APM and ACPI are in USE ... defaulting to ACPI"
	use apm || use acpi || eerror "Neither APM or ACPI are in USE ... defaulting to ACPI"
	if [ `use acpi` ] || [ ! `use apm` ] ; then
		epatch ${FILESDIR}/${PV}-acpi.patch
	else
		epatch ${FILESDIR}/${PV}-apm.patch
	fi
}

src_compile() {
	emake OPT="${CFLAGS}" || die
}

src_install() {
	dobin wmacpi
	dodoc AUTHORS ChangeLog README
}
