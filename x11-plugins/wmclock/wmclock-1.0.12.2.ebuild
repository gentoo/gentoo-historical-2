# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmclock/wmclock-1.0.12.2.ebuild,v 1.1 2003/10/03 22:56:12 pyrania Exp $

IUSE=""

DESCRIPTION="applet which displays the date and time in a dockable tile in the same style as the clock from the NEXTSTEP(tm) operating system"
SRC_URI="http://www.jmknoble.net/WindowMaker/wmclock/${P}.tar.gz"
HOMEPAGE="http://www.jmknoble.net/WindowMaker/wmclock/"

SLOT="0"
KEYWORDS="~x86"
LICENSE="GPL-2"

DEPEND="virtual/glibc
	virtual/x11
	x11-wm/windowmaker"

src_compile() {
	econf || die "configure failed"

	emake || die "make failed"
}

src_install () {
	into /usr/X11R6
	strip wmclock
	dobin wmclock

	newman wmclock.man wmclock.1

	dodoc README ChangeLog
}
