# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xsimpsons/xsimpsons-0.1.ebuild,v 1.3 2004/04/18 23:59:02 mr_bones_ Exp $

DESCRIPTION="The Simpsons walking along the tops of your windows."
HOMEPAGE="http://lightning.prohosting.com/~sbeyer/"
SRC_URI="http://lightning.prohosting.com/~sbeyer/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="virtual/x11"

src_compile() {
	emake || die "emake failed"
}

src_install() {
	dobin xsimpsons || die "dobin failed"
}
