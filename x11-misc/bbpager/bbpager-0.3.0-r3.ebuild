# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Gontran Zepeda <gontran@gontran.net>
# $Header: /var/cvsroot/gentoo-x86/x11-misc/bbpager/bbpager-0.3.0-r3.ebuild,v 1.2 2002/07/08 16:58:05 aliz Exp $

S=${WORKDIR}/${P}
DESCRIPTION="An understated pager for Blackbox."
SRC_URI="http://bbtools.windsofstorm.net/sources/${P}.tar.gz"
HOMEPAGE="http://bbtools.windsofstorm.net/available.phtml#bbpager"
LICENSE="GPL-2"

DEPEND="virtual/blackbox"

src_unpack () {
	unpack ${A} ; cd ${S}
	patch -p1 < ${FILESDIR}/bbpager-gcc3.patch	
}

src_compile() {
	./configure --prefix=/usr --host=${CHOST} || die
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc README TODO NEWS ChangeLog
}

pkg_postinst() {
	if [ "`use gnome`" ] ; then
		cd ${ROOT}usr/X11R6/bin/wm
		if [ ! "`grep bbpager blackbox`" ] ; then
		sed -e "s:.*blackbox:exec /usr/bin/bbpager \&\n&:" \
			blackbox | cat > blackbox
		fi
	fi
}
