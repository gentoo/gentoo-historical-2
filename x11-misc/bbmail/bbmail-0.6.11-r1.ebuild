# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Craig Joly <joly@ee.ualberta.ca>
# $Header: /var/cvsroot/gentoo-x86/x11-misc/bbmail/bbmail-0.6.11-r1.ebuild,v 1.1 2001/10/06 15:30:16 danarmak Exp $

S=${WORKDIR}/${P}
DESCRIPTION="blackbox mail notification, patched for maildir"
SRC_URI="http://bbtools.thelinuxcommunity.org/sources/${P}.tar.gz"
HOMEPAGE="http://bbtools.thelinuxcommunity.org/available.phtml"

DEPEND=">=x11-wm/blackbox-0.61"

src_unpack () {
	unpack ${A}
	cd ${S}
	# This is a patch for bbmail to support qmail style maildirs
	patch -p1 < ${FILESDIR}/bbmail-qmail.patch || die
}

src_compile() {
	./configure --prefix=/usr --host=${CHOST} || die
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc AUTHORS BUGS COPYING ChangeLog INSTALL NEWS README TODO data/README.bbmail
}

pkg_postinst() {
	cd ${ROOT}usr/X11R6/bin/wm
	if [ ! "`grep bbmail blackbox`" ] ; then
	sed -e "s/.*blackbox/exec \/usr\/bin\/bbmail \&\n&/" blackbox | cat > blackbox
	fi
}
