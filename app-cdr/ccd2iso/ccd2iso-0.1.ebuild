# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/ccd2iso/ccd2iso-0.1.ebuild,v 1.11 2005/04/21 17:52:09 blubb Exp $

DESCRIPTION="Converts CloneCD images (popular under Windows) to ISOs"
HOMEPAGE="http://sourceforge.net/projects/ccd2iso/"
SRC_URI="mirror://sourceforge/ccd2iso/${PN}.tar.gz"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="x86 ppc amd64 ~ppc-macos"

IUSE=""

DEPEND="virtual/libc"

S=${WORKDIR}/${PN}

src_install() {
	make install DESTDIR=${D} || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}
