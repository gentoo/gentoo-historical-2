# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/gscanbus/gscanbus-0.7.1.ebuild,v 1.7 2004/06/24 22:09:07 agriffis Exp $

inherit eutils

DESCRIPTION="gscanbus is a little bus scanning, testing and topology visualizing tool for the Linux IEEE1394 subsystem"
HOMEPAGE="http://gscanbus.berlios.de/"
SRC_URI="http://download.berlios.de/gscanbus/${P}.tgz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~sparc ppc ~amd64"
IUSE=""

DEPEND=">=sys-libs/libraw1394-0.9.0
	>=x11-libs/gtk+-1.2"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/gscanbus-0.71-gcc33.patch
}

src_install() {
	dobin gscanbus
	dodir /etc
	cp guid-resolv.conf oui-resolv.conf ${D}/etc
	dodoc README

}
