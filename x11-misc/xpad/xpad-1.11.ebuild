# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xpad/xpad-1.11.ebuild,v 1.1 2003/09/23 01:19:07 pylon Exp $

IUSE=""

DESCRIPTION="A GTK+ 2.0 based 'post-it' note system."
HOMEPAGE="http://xpad.sourceforge.net/"
SRC_URI="mirror://sourceforge/xpad/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~sparc ~ppc"

DEPEND=">=x11-libs/gtk+-2.0.0"

src_install () {
	make DESTDIR=${D} install || die "Installation failed"
	dodoc CHANGES COPYING README TODO
}
