# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/kvisualboyadvance/kvisualboyadvance-0.3.1.ebuild,v 1.2 2004/04/15 22:48:23 mr_bones_ Exp $

inherit kde
need-kde 3.2

DESCRIPTION="A front end for VisualBoyAdvance for KDE"
HOMEPAGE="http://kvisualboyadvance.openlindows.com/"
SRC_URI="http://kvisualboyadvance.openlindows.com/downloads/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="x86"
IUSE=""

RDEPEND="${RDEPEND} games-emulation/visualboyadvance"
