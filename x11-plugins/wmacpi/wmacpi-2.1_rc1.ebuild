# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmacpi/wmacpi-2.1_rc1.ebuild,v 1.5 2007/03/04 20:13:48 peper Exp $

inherit eutils

IUSE=""
DESCRIPTION="WMaker DockApp: ACPI status monitor for laptops"
HOMEPAGE="http://himi.org/wmacpi/"
MY_PV="2.1rc1"
MY_P="${PN}-${MY_PV}"
S="${WORKDIR}/${MY_P}"
SRC_URI="http://himi.org/wmacpi/download/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 -ppc -sparc x86"

DEPEND="x11-libs/libdockapp"

src_unpack()
{
	unpack ${A}
	epatch ${FILESDIR}/${MY_PV}-windowed.patch
	epatch ${FILESDIR}/${MY_PV}-nodeps.patch
}

src_compile()
{
	emake OPT="${CFLAGS}" || die
}

src_install()
{
	# Fix for #60685:
	# acpi and acpi.1 conflict with package sys-power/acpi
	mv acpi   acpi-batt-status
	mv acpi.1 acpi-batt-status.1

	dobin wmacpi acpi-batt-status
	doman wmacpi.1 acpi-batt-status.1
	dodoc AUTHORS ChangeLog README
}
