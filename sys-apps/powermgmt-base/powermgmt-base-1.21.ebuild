# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/powermgmt-base/powermgmt-base-1.21.ebuild,v 1.1 2005/01/29 07:19:37 genstef Exp $

DESCRIPTION="Script to test whether computer is running on AC power"
HOMEPAGE="http://packages.debian.org/testing/utils/powermgmt-base"
SRC_URI="mirror://debian/pool/main/p/${PN}/${PN}_${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~x86"
IUSE=""

RDEPEND="sys-apps/gawk"

src_install() {
	dodir /usr/bin
	make DESTDIR=${D} install || die
	doman man/acpi_available.1 man/apm_available.1 man/on_ac_power.1
	newdoc debian/powermgmt-base.README.Debian README
	dodoc debian/copyright debian/changelog
}
