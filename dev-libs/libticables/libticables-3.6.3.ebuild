# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libticables/libticables-3.6.3.ebuild,v 1.4 2004/04/26 01:14:09 agriffis Exp $

DESCRIPTION="libticables is a necessary library for the TiLP calculator linking program."
HOMEPAGE="http://tilp.sourceforge.net/"

# Should figure out a way to allow downloads from different server, rather than
# forcing it to come from Time-Warner
SRC_URI="mirror://sourceforge/tilp/libticables-3.6.3.tar.gz"
LICENSE="GPL-2"
SLOT="0"
# Only tested on x86 so far...
KEYWORDS="x86"
IUSE=""
DEPEND=""

src_compile() {
	econf || die "econf failed"
	emake || die
}

src_install() {
	einstall
}
