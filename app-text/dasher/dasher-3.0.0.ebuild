# Copyright 2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/app-text/dasher/dasher-3.0.0.ebuild,v 1.1 2003/03/16 22:15:42 sethbc Exp $

DESCRIPTION="information-efficient text-entry interface, \
	driven by natural continuous pointing gestures"
HOMEPAGE="http://www.inference.phy.cam.ac.uk/dasher/"
SRC_URI="http://www.inference.phy.cam.ac.uk/dasher/download/linux/source/3.0/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"

DEPEND="x11-libs/gtkmm"

KEYWORDS="~x86 ~ppc ~sparc ~alpha"

src_unpack() {
		unpack ${A}
}

src_compile() {
        econf || die "bad ./configure"
        make || die "compile problem"
}

src_install() {
        make install DESTDIR=${D} || die
}
											
