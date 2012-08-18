# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-firmware/iwl3945-ucode/iwl3945-ucode-15.32.2.9.ebuild,v 1.1 2012/08/18 20:14:28 ulm Exp $

MY_P="iwlwifi-3945-ucode-${PV}"

DESCRIPTION="Intel (R) PRO/Wireless 3945ABG Network Connection ucode"
HOMEPAGE="http://intellinuxwireless.org/?p=iwlwifi"
SRC_URI="http://intellinuxwireless.org/iwlwifi/downloads/${MY_P}.tgz"

LICENSE="ipw3945"
SLOT="1"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="|| ( >=sys-fs/udev-096 >=sys-apps/hotplug-20040923 )"
RDEPEND=""

S=${WORKDIR}/${MY_P}

src_compile() {
	true;
}

src_install() {
	insinto /lib/firmware
	doins iwlwifi-3945-2.ucode || die
	dodoc README*
}

pkg_postinst() {
	elog
	elog "Due to ucode API change this version of ucode works only with kernels"
	elog ">=2.6.29-rc1. If you have to use older kernels please install ucode"
	elog "with older API:"
	elog "emerge ${CATEGORY}/${PN}:0"
	elog "For more information take a look at bugs.gentoo.org/246045"
	elog
}
