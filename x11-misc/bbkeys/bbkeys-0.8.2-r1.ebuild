# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Joe Bormolini <lordjoe@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/x11-misc/bbkeys/bbkeys-0.8.2-r1.ebuild,v 1.1 2001/08/30 06:50:04 woodchip Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Use keyboard shortcuts in the blackbox wm"
HOMEPAGE="http://movingparts.thelinuxcommunity.org"
SRC_URI="http://movingparts.thelinuxcommunity.org/bbkeys/${P}.tar.gz"

DEPEND=">=x11-wm/blackbox-0.61"

src_compile() {
	./configure --prefix=/usr/X11R6 --host=${CHOST} || die
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	rm -rf ${D}/usr/X11R6/doc
	dodoc AUTHORS ChangeLog README
}

pkg_postinst() {
	cd ${ROOT}usr/X11R6/bin/wm
	sed -e "s/.*blackbox/exec \/usr\/X11R6\/bin\/bbkeys \&\n&/" blackbox | cat > blackbox
}
