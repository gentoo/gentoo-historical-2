# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libdnet/libdnet-1.7.ebuild,v 1.10 2004/07/14 14:33:32 agriffis Exp $

DESCRIPTION="simplified, portable interface to several low-level networking routines"
HOMEPAGE="http://libdnet.sourceforge.net/"
SRC_URI="mirror://sourceforge/libdnet/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc hppa ~ia64 ~amd64"
IUSE=""

src_install () {
	einstall || die
	dodoc COPYING.LIB ChangeLog VERSION README
}
