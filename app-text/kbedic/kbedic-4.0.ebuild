# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/kbedic/kbedic-4.0.ebuild,v 1.6 2005/01/01 16:23:54 eradicator Exp $

inherit kde

DESCRIPTION="English <-> Bulgarian Dictionary"
HOMEPAGE="http://kbedic.sourceforge.net"
SRC_URI="mirror://sourceforge/kbedic/$P.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"
IUSE="kde"

DEPEND=">=x11-libs/qt-3
	kde? ( >=kde-base/kdelibs-3 )"

src_compile() {
	use kde && myconf="$myconf --with-kde" || myconf="$myconf --prefix=/usr"
	use kde && kde_src_compile myconf
	kde_src_compile configure make
}

src_install() {
	kde_src_install
	use kde && install -m 644 -D ${FILESDIR}/kbedic.desktop ${D}/usr/share/applnk/Utilities/kbedic.desktop
}

