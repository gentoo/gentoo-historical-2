# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/bbmail/bbmail-0.8.2.ebuild,v 1.5 2003/02/13 17:08:20 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="blackbox mail notification"
SRC_URI="http://bbtools.windsofstorm.net/sources/${P}.tar.gz"
HOMEPAGE="http://bbtools.windsofstorm.net/available.phtml#bbmail"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc "

DEPEND="virtual/blackbox"

src_compile() {
	econf || die
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	dobin scripts/bbmailparsefm.pl
	dodoc AUTHORS BUGS COPYING ChangeLog INSTALL NEWS README TODO
}
