# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/autoprofile/autoprofile-2.08.ebuild,v 1.4 2004/09/18 01:13:27 rizzo Exp $

DESCRIPTION="AutoProfile is a fully-featured profile manager for the popular instant messenger client Gaim."
HOMEPAGE="http://hkn.eecs.berkeley.edu/~casey/autoprofile/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ppc"
IUSE=""
DEPEND=">=net-im/gaim-0.82
	<net-im/gaim-1.0.0"

src_compile() {
	emake || die
}

src_install() {
	dodir /usr/lib/gaim
	make install PREFIX=${D}/usr || die "make install failed"

	dodoc COPYING CHANGELOG INSTALL README TODO
}
