# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/kvpnc/kvpnc-0.4.1.2.ebuild,v 1.4 2005/05/06 14:28:00 voxus Exp $

inherit kde

DESCRIPTION="kvpnc - a KDE-VPN connection utility."
SRC_URI="http://download.gna.org/${PN}/${P}.tar.gz"
HOMEPAGE="http://home.gna.org/${PN}/"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"
IUSE=""
SLOT="0"

DEPEND=">=net-misc/vpnc-0.2"
need-kde 3.2
