# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/gputils/gputils-0.10.6.ebuild,v 1.1 2003/10/20 06:44:06 robbat2 Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Utils for the PICxxx procesors"
SRC_URI="mirror://sourceforge/gputils/${P}.tar.gz"
HOMEPAGE="http://gputils.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc "

DEPEND="virtual/glibc"

src_compile() {
	econf || die
	emake || die
}

src_install() {
	einstall || die
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README TODO
	dodoc doc/gputils.ps
}
