# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/ktraynetworker/ktraynetworker-0.7.ebuild,v 1.1 2004/06/23 22:35:26 centic Exp $

inherit kde
need-kde 3.2

DESCRIPTION="A KDE 3.x Network monitoring applet"
HOMEPAGE="http://www.xiaprojects.com/www/prodotti/ktraynetworker/main.php"
SRC_URI="http://www.xiaprojects.com/www/downloads/files/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~x86"

IUSE=""
SLOT="0"

src_compile()
{
	# aclocal needs to be run because the source contains files that are too old...
	aclocal
	econf || die "econf failed!"
	emake || die "emake failed!"
}

