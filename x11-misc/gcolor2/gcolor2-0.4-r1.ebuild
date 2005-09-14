# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/gcolor2/gcolor2-0.4-r1.ebuild,v 1.1 2005/09/14 20:07:02 ka0ttic Exp $

inherit eutils

DESCRIPTION="A simple GTK+2 color selector."
HOMEPAGE="http://gcolor2.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~ppc64 ~x86"
IUSE=""

DEPEND=">=x11-libs/gtk+-2.4"

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodoc INSTALL AUTHORS COPYING
	make_desktop_entry gcolor2 gcolor2 /usr/share/pixmaps/gcolor2/icon.png Graphics
}
