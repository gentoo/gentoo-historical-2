# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/kmymoney2/kmymoney2-0.6.ebuild,v 1.2 2004/06/24 22:41:49 agriffis Exp $

inherit kde-base
need-kde 3

DESCRIPTION="Personal Finances Manager for KDE"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
HOMEPAGE="http://kmymoney2.sourceforge.net"

LICENSE="GPL-2"
KEYWORDS="~x86 ~sparc ~ppc"

IUSE=""
SLOT="0"

DEPEND="dev-libs/libxml2
	dev-cpp/libxmlpp"

#S="${WORKDIR}/${MY_P}"

