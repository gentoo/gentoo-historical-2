# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-mobilephone/kmobiletools/kmobiletools-0.4.3.3.ebuild,v 1.5 2008/02/19 01:19:27 ingmar Exp $

inherit kde

DESCRIPTION="KMobiletools is a KDE-based application that allows to control mobile phones with your PC."
SRC_URI="http://download.berlios.de/${PN}/${P}.tar.bz2"
HOMEPAGE="http://www.kmobiletools.org/"
LICENSE="GPL-2"

IUSE=""
KEYWORDS="~amd64 ~ppc x86"

need-kde 3.2

src_unpack() {
	kde_src_unpack

	rm -f "${S}/configure"
}

src_install() {
	kde_src_install

	dodir /usr/share/applications/kde
	# Move the .desktop file in FDO's defined directory
	mv "${D}"/usr/share/applnk/Utilities/kmobiletools.desktop \
		"${D}"/usr/share/applications/kde || die "Moving kmobiletools.desktop failed."
}
