# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/kwavecontrol/kwavecontrol-0.2.ebuild,v 1.6 2004/06/25 00:45:52 agriffis Exp $

PATCHES="${FILESDIR}/${P}-gcc-2.95.3.diff"
newdepend "net-wireless/wireless-tools"
inherit kde
need-kde 3
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://kwavecontrol.sourceforge.net/"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc"
IUSE=""
DESCRIPTION="KWaveControl is a little tool for WaveLAN wireless cards based on the wireless extensions."
