# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/openhbci/openhbci-0.9.13.ebuild,v 1.1 2003/08/28 21:25:58 hanno Exp $

DESCRIPTION="Implementation of the HBCI protocol used by some banks"
HOMEPAGE="http://openhbci.sourceforge.net/"
SRC_URI="mirror://sourceforge/openhbci/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-libs/openssl-0.9.6
	>=sys-libs/libchipcard-0.8"

src_compile() {
	econf --with-chipcard=/usr || die "configure failed"
	emake || die "parallel make failed"
}

src_install() {
	make DESTDIR=${D} install || die "install failed"
	dodoc AUTHORS README TODO
}
