# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/kmymoney2/kmymoney2-0.6.ebuild,v 1.5 2005/01/01 15:35:35 eradicator Exp $

inherit kde


DESCRIPTION="Personal Finances Manager for KDE"
HOMEPAGE="http://kmymoney2.sourceforge.net"
SRC_URI="mirror://sourceforge/kmymoney2/${P}.tar.bz2"


LICENSE="GPL-2"
KEYWORDS="~x86 ~sparc ~ppc ~amd64"

IUSE=""
SLOT="0"

DEPEND="dev-libs/libxml2
	dev-cpp/libxmlpp"
need-kde 3


