Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Joe Bormolini <lordjoe@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-misc/bbweather/bbweather-0.3.ebuild,v 1.4 2001/08/30 19:53:26 woodchip Exp $

S=${WORKDIR}/${P}
DESCRIPTION="blackbox weather monitor"
SRC_URI="http://www.netmeister.org/apps/${P}.tar.bz2"
HOMEPAGE="http://www.netmeister.org/apps/bbweather/index.html"

DEPEND=">=x11-wm/blackbox-0.61
        >=net-misc/wget-1.7
        >=sys-devel/perl-5.6.1"

src_compile() {
	./configure --prefix=/usr/X11R6 --host=${CHOST} || die
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc README COPYING AUTHORS INSTALL ChangeLog NEWS TODO data/README.bbweather
}
