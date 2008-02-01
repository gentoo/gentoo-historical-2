# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/iwl4965-ucode/iwl4965-ucode-4.44.1.20.ebuild,v 1.2 2008/02/01 17:23:56 opfer Exp $

MY_PN="iwlwifi-4965-ucode"

DESCRIPTION="Intel (R) PRO/Wireless 3945ABG Network Connection ucode"
HOMEPAGE="http://intellinuxwireless.org/?p=iwlwifi"
SRC_URI="http://intellinuxwireless.org/iwlwifi/downloads/${MY_PN}-${PV}.tgz"

LICENSE="Intel"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="|| ( >=sys-fs/udev-096 >=sys-apps/hotplug-20040923 )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}"

src_compile() {
	true;
}

src_install() {
	insinto /lib/firmware
	doins "${S}/iwlwifi-4965-1.ucode"

	dodoc README*
}
