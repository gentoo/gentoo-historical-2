# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/jal/jal-0.4.60.ebuild,v 1.2 2007/07/15 03:57:21 mr_bones_ Exp $

DESCRIPTION="A high-level language for a number of Microchip PIC and Ubicom SX microcontrollers."
HOMEPAGE="http://jal.sourceforge.net/"
SRC_URI="mirror://sourceforge/jal/${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="x86"
SLOT="0"
IUSE=""
DEPEND="virtual/libc"

src_install() {
	make DESTDIR=${D} install || die
}
