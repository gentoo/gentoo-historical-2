# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/cnetworkmanager/cnetworkmanager-0.21-r1.ebuild,v 1.1 2009/08/14 10:25:02 dagger Exp $

EAPI=2

inherit distutils

DESCRIPTION="Command line interface for NetworkManager."
HOMEPAGE="http://vidner.net/martin/software/cnetworkmanager/"
SRC_URI="http://vidner.net/martin/software/cnetworkmanager/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm ~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-lang/python-2.5
	>=dev-python/dbus-python-0.80.2
	>=dev-python/pygobject-2.14.0
	>=net-misc/networkmanager-0.7.0"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	# Fixes bug 281099
	epatch "${FILESDIR}"/${P}-wepwapfix.patch
}
