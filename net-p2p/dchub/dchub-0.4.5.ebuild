# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/dchub/dchub-0.4.5.ebuild,v 1.6 2004/07/01 09:13:42 squinky86 Exp $

IUSE=""

HOMEPAGE="http://www.ac2i.tzo.com/dctc/#dchub"
DESCRIPTION="dchub (Direct Connect Hub), a linux hub for the p2p 'direct connect'"
SRC_URI="http://ac2i.tzo.com/dctc/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc"

RDEPEND="virtual/libc
	=dev-libs/glib-1*
	dev-lang/perl
	dev-db/edb"

src_install() {
	einstall || die "install problem"

	dodoc Documentation/*
	dodoc AUTHORS COPYING ChangeLog NEWS README TODO

	dodir /etc/{conf,init}.d /etc/dchub
	exeinto /etc/init.d
	newexe ${FILESDIR}/dchub.init.d dchub
	insinto /etc/conf.d
	newins ${FILESDIR}/dchub.conf.d dchub
}
