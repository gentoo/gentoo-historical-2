# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pymsn/pymsn-0.3.3.ebuild,v 1.2 2008/12/24 10:08:07 bluebird Exp $

inherit distutils

DESCRIPTION="The library behind the msn connection manager: telepathy-butterfly"
HOMEPAGE="http://telepathy.freedesktop.org/wiki/Pymsn"
SRC_URI="http://telepathy.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE=""

DEPEND="
	>=dev-lang/python-2.4
	|| (
		>=dev-lang/python-2.5
		dev-python/elementtree
		dev-python/celementtree
		)
	>=dev-python/pygtk-2.10.0
	>=dev-python/pyopenssl-0.6
	dev-python/pycrypto"
RDEPEND="${DEPEND}"

DOCS="AUTHORS NEWS README"
