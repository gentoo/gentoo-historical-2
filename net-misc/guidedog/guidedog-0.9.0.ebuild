# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/guidedog/guidedog-0.9.0.ebuild,v 1.7 2004/06/24 23:47:16 agriffis Exp $

inherit kde

need-kde 3

DESCRIPTION="A network/routing configuration utility for KDE 3"
SRC_URI="http://www.simonzone.com/software/guidedog/${P}.tar.gz"
HOMEPAGE="http://www.simonzone.com/software/guidedog/"
LICENSE="GPL-2"
KEYWORDS="x86"
SLOT="0"
IUSE=""

newdepend ">=net-firewall/iptables-1.2.5"

