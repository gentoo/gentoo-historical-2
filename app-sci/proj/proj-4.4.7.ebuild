# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/proj/proj-4.4.7.ebuild,v 1.1 2003/08/30 09:58:07 twp Exp $

DESCRIPTION="Cartographic projections library"
HOMEPAGE="http://www.remotesensing.org/proj/"
SRC_URI="ftp://ftp.remotesensing.org/pub/proj/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

DEPEND="virtual/glibc"
PROVIDE="dev-libs/proj"

src_compile() {
	econf || die "./configure failed"
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog COPYING INSTALL NEWS README
}
