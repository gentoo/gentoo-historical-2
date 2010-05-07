# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/linux-firmware/linux-firmware-99999999.ebuild,v 1.3 2010/05/07 18:11:40 robbat2 Exp $

inherit git

DESCRIPTION="Linux firmware files"
HOMEPAGE="http://www.kernel.org/pub/linux/kernel/people/dwmw2/firmware"
SRC_URI=""
EGIT_REPO_URI="git://git.kernel.org/pub/scm/linux/kernel/git/dwmw2/${PN}.git"

LICENSE="GPL-2 freedist"
SLOT="0"
KEYWORDS=""

DEPEND=""
RDEPEND="!net-wireless/iwl3945-ucode
	!net-wireless/ralink-firmware
	!net-wireless/iwl4965-ucode
	!net-wireless/iwl5000-ucode"
#add anything else that collides to this

src_install() {
	insinto /lib/firmware/
	doins -r * || die "Install failed!"
}
