# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/dchub/dchub-0.5.2.ebuild,v 1.2 2004/08/09 02:56:24 squinky86 Exp $

IUSE=""

HOMEPAGE="http://ac2i.homelinux.com/dctc/#dchub"
DESCRIPTION="dchub (Direct Connect Hub), a linux hub for the p2p 'direct connect'"
SRC_URI="http://ac2i.homelinux.com/dctc/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc"

RDEPEND="virtual/libc
	=dev-libs/glib-1*
	dev-lang/perl
	dev-db/edb"

src_install() {
	make DESTDIR=${D} install || die "install problem"

	dodoc Documentation/*
	dodoc AUTHORS COPYING ChangeLog NEWS README TODO

	dodir /etc/{conf,init}.d /etc/dchub
	exeinto /etc/init.d
	newexe ${FILESDIR}/dchub.init.d dchub
	insinto /etc/conf.d
	newins ${FILESDIR}/dchub.conf.d dchub
}
