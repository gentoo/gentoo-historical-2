# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/kmldonkey/kmldonkey-0.9.1.ebuild,v 1.3 2003/09/14 10:58:13 dholm Exp $

inherit kde-base

need-kde 3

LICENSE="GPL-2"
KEYWORDS="x86 ~ppc"
SLOT="0"

DESCRIPTION="Provides integration for the MLDonkey P2P software and KDE 3"
SRC_URI="http://savannah.nongnu.org/download/kmldonkey/unstable.pkg/${PV}/${P}.tar.gz"
HOMEPAGE="http://www.gibreel.net/projects/kmldonkey"

pkg_postinst() {
	echo
	echo
	einfo "To configure Kmldonkey use your KDE ControlCenter"
	einfo "To load the Kmldonkey GUI interface, just add the"
	einfo "MLDonkeyApplet miniprog to your taskbar"
	echo
	echo
}
