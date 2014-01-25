# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-firmware/iwl3160-ucode/iwl3160-ucode-22.15.8.0.ebuild,v 1.1 2014/01/25 03:35:32 gienah Exp $

EAPI=5
inherit linux-info

DEV_N="${PN:3:4}"
MY_PN="iwlwifi-${DEV_N}-ucode"

DESCRIPTION="Firmware for Intel (R) Dual Band Wireless-AC ${DEV_N}"
HOMEPAGE="http://wireless.kernel.org/en/users/Drivers/iwlwifi"
SRC_URI="http://wireless.kernel.org/en/users/Drivers/iwlwifi?action=AttachFile&do=get&target=${MY_PN}-${PV}.tgz -> ${P}.tgz"

LICENSE="ipw3945"
SLOT="1"
KEYWORDS="~amd64 ~x86"
IUSE="bluetooth"

DEPEND=""
RDEPEND="bluetooth? ( sys-firmware/iwl3160-7260-bt-ucode )
	!sys-kernel/linux-firmware[-savedconfig]"

S="${WORKDIR}/${MY_PN}-${PV}"

CONFIG_CHECK="IWLMVM"
ERROR_IWLMVM="CONFIG_IWLMVM is required to be enabled in /usr/src/linux/.config for the kernel to be able to load the ${DEV_N} firmware"

pkg_pretend() {
	if kernel_is lt 3 13 0; then
		ewarn "Your kernel version is ${KV_MAJOR}.${KV_MINOR}.${KV_PATCH}."
		ewarn "This microcode image requires a kernel >= 3.13.0."
		ewarn "For kernel versions < 3.10.13, you may install older SLOTS"
	fi
}

src_install() {
	insinto /lib/firmware
	doins "${S}/iwlwifi-${DEV_N}-8.ucode"
	dodoc README*
}
