# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/biosdisk/biosdisk-0.50.ebuild,v 1.1.1.1 2005/11/30 09:56:14 chriswhite Exp $

DESCRIPTION="A script that creates floppy boot images to flash Dell BIOSes"
HOMEPAGE="http://linux.dell.com/projects.shtml#biosdisk"
SRC_URI="http://linux.dell.com/biosdisk/permalink/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86"
IUSE=""
RDEPEND="app-text/unix2dos"

src_install() {
	dosbin biosdisk
	dodoc AUTHORS CHANGELOG README README.dosdisk TODO VERSION
	doman biosdisk.8.gz

	insinto /var/lib/biosdisk
	doins dosdisk.img

	insinto /etc/biosdisk
	doins biosdisk.conf
	doins biosdisk-mkrpm-template.spec
}
