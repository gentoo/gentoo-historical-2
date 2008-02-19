# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/kmldonkey/kmldonkey-0.10.1-r1.ebuild,v 1.5 2008/02/19 02:02:02 ingmar Exp $

inherit kde eutils

DESCRIPTION="Provides integration for the MLDonkey P2P software and KDE 3"
HOMEPAGE="http://www.kmldonkey.org/"
SRC_URI="http://savannah.nongnu.org/download/kmldonkey/${P}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="|| ( =kde-base/kcontrol-3.5* =kde-base/kdebase-3.5* )"

need-kde 3.5

src_unpack() {
	kde_src_unpack

	epatch "${FILESDIR}/${P}-sandbox.patch"
	epatch "${FILESDIR}/${P}-failed-dialog-189334.diff"
	rm -f "${S}/configure"
}

pkg_postinst() {
	echo
	einfo "To configure Kmldonkey, you can use the KDE Control Center."
	echo
}
