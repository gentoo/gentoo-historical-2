# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/guidedog/guidedog-0.9.0.ebuild,v 1.1.1.1 2005/11/30 09:54:30 chriswhite Exp $

inherit kde

DESCRIPTION="A network/routing configuration utility for KDE 3"
HOMEPAGE="http://www.simonzone.com/software/guidedog/"
SRC_URI="http://www.simonzone.com/software/guidedog/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"
IUSE=""

DEPEND=">=net-firewall/iptables-1.2.5"
need-kde 3