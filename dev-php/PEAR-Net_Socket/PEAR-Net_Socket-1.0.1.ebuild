# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-Net_Socket/PEAR-Net_Socket-1.0.1.ebuild,v 1.9 2004/04/17 15:02:28 aliz Exp $

MY_P=${PN/PEAR-//}-${PV}
DESCRIPTION="class interface to TCP sockets"
HOMEPAGE="http://pear.php.net/package-info.php?pacid=64"
SRC_URI="http://pear.php.net/get/${MY_P}.tgz"
IUSE=""
LICENSE="PHP"
SLOT="0"
KEYWORDS="x86 ~ppc ~alpha ~sparc"

DEPEND="virtual/php"

src_install() {
	insinto /usr/lib/php/Net
	doins Socket.php
}
