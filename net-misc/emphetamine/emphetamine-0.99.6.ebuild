# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/emphetamine/emphetamine-0.99.6.ebuild,v 1.4 2004/06/24 23:43:15 agriffis Exp $

inherit gnome2

DESCRIPTION="GNOME-based download manager."
SRC_URI="mirror://sourceforge/emphetamine/${P}.tar.gz"
HOMEPAGE="http://emphetamine.sourceforge.net"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="x11-libs/libelysium
		x11-libs/libelysiumui"

#RDEPEND=""
S=${WORKDIR}/${P}
