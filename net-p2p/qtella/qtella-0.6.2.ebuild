# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/qtella/qtella-0.6.2.ebuild,v 1.4 2003/09/08 08:58:42 lanius Exp $
inherit kde-base

IUSE="kde"
use kde && need-kde 3 || need-qt 3

SRC_URI="mirror://sourceforge/qtella/${P}.tar.gz"
HOMEPAGE="http://www.qtella.net"
DESCRIPTION="Excellent QT/KDE Gnutella Client"

SLOT="3" # why??
LICENSE="GPL-2"
KEYWORDS="x86"
export MAKEOPTS="$MAKEOPTS -j1"

# weird workaround
#PATCHES="${FILESDIR}/${P}-nokde.diff"

src_compile() {
	kde_src_compile myconf
	use kde || myconf="$myconf --with-kde=no"
	kde_src_compile configure make
}
