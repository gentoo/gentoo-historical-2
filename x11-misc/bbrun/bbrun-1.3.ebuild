# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Craig Joly <joly@ee.ualberta.ca>
# $Header: /var/cvsroot/gentoo-x86/x11-misc/bbrun/bbrun-1.3.ebuild,v 1.1 2002/04/14 05:55:26 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="blackbox program execution dialog box"
SRC_URI="http://www.dwave.net/~jking/bbrun/${P}.tar.gz"
HOMEPAGE="http://www.dwave.net/~jking/bbrun/"

DEPEND="virtual/blackbox
        >=x11-libs/gtk+-1.2.10-r4"

src_unpack() {
	unpack ${A}
	cd ${S}/bbrun
	mv Makefile Makefile.orig
	sed '/CFLAGS =/ s:$: -I/usr/include/gtk-1.2 -I/usr/include/glib-1.2 '"${CFLAGS}"':' Makefile.orig > Makefile || die
}

src_compile() {

	cd ${S}/bbrun
	emake || die

}

src_install () {

	into /usr
	dobin bbrun/bbrun
	dodoc README COPYING

}

pkg_postinst() {

	cd ${ROOT}etc/X11/Sessions

	if [ ! "`grep bbrun blackbox`" ]
	then
		sed -e "s:.*blackbox:exec /usr/bin/bbrun \&\n&:" \
			blackbox | cat > blackbox
	fi

}
