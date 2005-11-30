# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/bfr/bfr-1.5.ebuild,v 1.1.1.1 2005/11/30 10:05:51 chriswhite Exp $

DESCRIPTION="Buffer (bfr) is a general-purpose command-line pipe buffer"
HOMEPAGE="http://www.glines.org/software/buffer.html"
SRC_URI="http://www.glines.org/bin/pk/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND=""

src_install() {
	make DESTDIR=${D} install || die "install failed"
	dodoc AUTHORS INSTALL ChangeLog NEWS README TODO
}
