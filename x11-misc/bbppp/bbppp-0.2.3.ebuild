# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/bbppp/bbppp-0.2.3.ebuild,v 1.3 2004/04/14 09:09:01 aliz Exp $

IUSE=""
DESCRIPTION="blackbox ppp frontend/monitor"
SRC_URI="http://bbtools.windsofstorm.net/sources/${P}.tar.gz"
HOMEPAGE="http://bbtools.windsofstorm.net/available.phtml#bbppp"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc "

DEPEND="virtual/blackbox"

src_compile() {
	econf || die
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc README COPYING AUTHORS BUGS INSTALL ChangeLog NEWS TODO data/README.bbppp
}

pkg_postinst() {
	cd ${ROOT}usr/X11R6/bin/wm
	if [ ! "`grep bbppp blackbox`" ] ; then
	sed -e "s/.*blackbox/exec \/usr\/bin\/bbppp \&\n&/" blackbox | cat > blackbox
	fi
}
