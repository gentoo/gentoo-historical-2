# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/varconf/varconf-0.5.0.ebuild,v 1.5 2002/12/09 04:26:14 manson Exp $

S="${WORKDIR}/${P}"
DESCRIPTION="A configuration system designed for the STAGE server."
SRC_URI="ftp://victor.worldforge.org/pub/worldforge/libs/varconf/${P}.tar.bz2"
HOMEPAGE="http://www.worldforge.net"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="x86 sparc "

DEPEND="virtual/glibc"

src_compile() {

	econf || die
	emake || die

}

src_install() {

	make DESTDIR=${D} install || die

	dodoc AUTHORS COPYING ChangeLog NEWS README THANKS TODO
}
