# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libyahoo2/libyahoo2-0.7.5.ebuild,v 1.2 2004/08/30 15:47:24 dholm Exp $

DESCRIPTION="libyahoo2 is an interface to the new Yahoo! Messenger protocol."
HOMEPAGE="http://libyahoo2.sourceforge.net/"
SRC_URI="mirror://sourceforge/libyahoo2/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""

src_compile() {
	econf || die
	emake || die
}

src_install() {
	einstall || die
	dobin src/yahoo
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README TODO
	dodoc doc/*.txt
	docinto sample
	dodoc src/sample_client.c src/sample_makefile

}
