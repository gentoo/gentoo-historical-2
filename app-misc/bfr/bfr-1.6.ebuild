# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/bfr/bfr-1.6.ebuild,v 1.3 2004/07/04 11:40:33 dholm Exp $

DESCRIPTION="Buffer (bfr) is a general-purpose command-line pipe buffer"
HOMEPAGE="http://www.glines.org:8000/software/buffer.html"
SRC_URI="http://www.glines.org:8000/bin/pk/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE=""

DEPEND=""

src_install() {
	einstall || die "install failed"
	dodoc AUTHORS INSTALL ChangeLog NEWS README TODO
}
