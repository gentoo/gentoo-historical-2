# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/kiosktool/kiosktool-0.7.ebuild,v 1.1 2004/08/21 12:25:04 voxus Exp $

inherit eutils kde-functions
need-qt 3

DESCRIPTION="KDE Kiosk GUI Admin Tool"
HOMEPAGE="http://extragear.kde.org/apps/kiosktool.php"
SRC_URI="ftp://ftp.kde.org/pub/kde/stable/apps/KDE3.x/admin/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="arts"
DEPEND=">=kde-base/kdebase-3.2.2
		arts? ( >=kde-base/arts-1.2.0 )"

src_compile() {
	use arts || myconf="${myconf} --without-arts"

	econf ${myconf} || die
	emake || die
}

src_install() {
	einstall || die

	dodoc ChangeLog README
}
