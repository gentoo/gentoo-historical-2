# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/physfs/physfs-0.1.9.ebuild,v 1.8 2004/04/29 19:48:42 agriffis Exp $

DESCRIPTION="abstraction layer for filesystems, useful for games"
HOMEPAGE="http://icculus.org/physfs/"
SRC_URI="http://icculus.org/physfs/downloads/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86 ppc sparc hppa amd64 ~alpha"

DEPEND="virtual/glibc"

src_install() {
	einstall || die "Installation failed"
	dodoc CHANGELOG CREDITS TODO docs/README
}
