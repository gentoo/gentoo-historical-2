# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/netprofiles-ims/netprofiles-ims-0.1.0134.ebuild,v 1.3 2004/06/24 23:59:49 agriffis Exp $

DESCRIPTION="The Netprofiles Interface Management System (IMS) is an easy way to manage multiple network configurations for your wired or wireless network cards."

HOMEPAGE="http://www.furuba.net/~buckminst/gentoo/"
SRC_URI="http://www.furuba.net/~buckminst/gentoo/netprofiles-ims-0.1.0134.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""
DEPEND=""

src_unpack() {
	unpack ${A}
	cd ${S}
}

src_install() {
	cd ${S}
	exeinto /usr/sbin
	dosbin netprofiles
	exeinto /etc/init.d
	doexe netprofiles-ims
}
