# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-laptop/gtkpbbuttons/gtkpbbuttons-0.6.4.ebuild,v 1.2 2005/01/01 14:46:11 eradicator Exp $

DESCRIPTION="program to monitor special Powerbook/iBook keys"
HOMEPAGE="http://pbbuttons.sf.net"
SRC_URI="mirror://sourceforge/pbbuttons/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~ppc"
IUSE=""

DEPEND=">=x11-libs/gtk+-2.0
	>=media-libs/audiofile-0.1.9
	>=app-laptop/pbbuttonsd-0.6.0"

src_compile() {
	econf || die
	make || die "compile failed"
}

src_install() {
	make install DESTDIR=${D} || die
	dodoc README
}
