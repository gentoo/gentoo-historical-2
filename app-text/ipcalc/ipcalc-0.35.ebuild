# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/ipcalc/ipcalc-0.35.ebuild,v 1.8 2004/07/13 22:08:35 agriffis Exp $

MY_PN="ipcalc"
MY_P="${MY_PN}-${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="ipcalc takes an IP address and netmask and calculates the resulting broadcast, network, Cisco wildcard mask, and host range."
HOMEPAGE="http://jodies.de/ipcalc"
SRC_URI="http://jodies.de/ipcalc-archive/${MY_P}.tar.gz"

DEPEND=">=dev-lang/perl-5.6.0"

KEYWORDS="x86 hppa ~amd64 sparc ~mips"
IUSE=""
SLOT="0"
LICENSE="as-is"

src_install () {
	newbin ${MY_PN} ${MY_PN}
}
