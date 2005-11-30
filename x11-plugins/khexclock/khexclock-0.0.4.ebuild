# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/khexclock/khexclock-0.0.4.ebuild,v 1.1.1.1 2005/11/30 10:10:45 chriswhite Exp $

inherit kde

IUSE=""
DESCRIPTION="KHexClock shows the current hexadecimal time and date."
HOMEPAGE="http://utopios.org/~luke-jr/programs/khexclock/"
SRC_URI="http://mystery.ryalth.com/~luke-jr/programs/khexclock/${P}.tbz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64 ppc"

need-kde 3
