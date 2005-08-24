# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libeXosip/libeXosip-0.9.0.ebuild,v 1.2 2005/08/24 12:59:57 dragonheart Exp $

inherit eutils

DESCRIPTION="eXosip is a library that hides the complexity of using the SIP protocol for mutlimedia session establishement."
HOMEPAGE="http://savannah.nongnu.org/projects/exosip/"
SRC_URI="http://savannah.nongnu.org/download/exosip/${P}.tar.gz"

SLOT="0"
KEYWORDS="~x86 ~ppc"
LICENSE="GPL-2"
IUSE=""
DEPEND=">=net-libs/libosip-2.2.0"

src_compile() {
	econf --disable-josua || die
	emake || die
}

src_install() {
	emake DESTDIR=${D} install || die
	dodoc README ChangeLog INSTALL AUTHORS COPYING NEWS
}
