# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/iwl3945-ucode/iwl3945-ucode-2.14.1.5.ebuild,v 1.3 2010/01/09 11:11:57 hanno Exp $

MY_PN="iwlwifi-3945-ucode"

DESCRIPTION="Intel (R) PRO/Wireless 3945ABG Network Connection ucode"
HOMEPAGE="http://intellinuxwireless.org/?p=iwlwifi"
SRC_URI="http://intellinuxwireless.org/iwlwifi/downloads/${MY_PN}-${PV}.tgz"

LICENSE="ipw3945"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="|| ( >=sys-fs/udev-096 >=sys-apps/hotplug-20040923 )"
RDEPEND=""

S="${WORKDIR}/${MY_PN}-${PV}"

src_compile() {
	true;
}

src_install() {
	insinto /lib/firmware
	doins iwlwifi-3945-1.ucode

	dodoc README*
}
