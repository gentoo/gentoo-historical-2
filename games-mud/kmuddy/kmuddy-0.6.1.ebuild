# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-mud/kmuddy/kmuddy-0.6.1.ebuild,v 1.4 2004/09/08 23:58:27 mr_bones_ Exp $

inherit eutils kde
need-kde 3

DESCRIPTION="MUD client for KDE"
HOMEPAGE="http://www.kmuddy.org"
SRC_URI="http://www.kmuddy.org/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

src_unpack() {
	kde_src_unpack
	cd "${S}/kmuddy"
	epatch "${FILESDIR}/${PV}-gcc34.patch"
}
