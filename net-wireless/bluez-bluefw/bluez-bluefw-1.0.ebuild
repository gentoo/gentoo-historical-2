# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/bluez-bluefw/bluez-bluefw-1.0.ebuild,v 1.5 2004/06/25 00:42:56 agriffis Exp $

inherit eutils

DESCRIPTION="Bluetooth USB Firmware Downloader"
HOMEPAGE="http://bluez.sourceforge.net/"
SRC_URI="http://bluez.sourceforge.net/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""

DEPEND="sys-apps/hotplug
	>=net-wireless/bluez-libs-2.2"

src_unpack() {
	unpack ${A}
	cd ${S}; epatch ${FILESDIR}/${PN}-0.9-kernel2.6.patch
}

src_compile() {
	econf --sbindir=/sbin || die "econf failed"
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc README AUTHORS ChangeLog
}
