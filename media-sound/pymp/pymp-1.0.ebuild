# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/pymp/pymp-1.0.ebuild,v 1.4 2007/07/07 18:12:44 armin76 Exp $

inherit eutils

DESCRIPTION="a lean, flexible frontend to mplayer written in python"
HOMEPAGE="http://jdolan.dyndns.org/trac/wiki/Pymp"
SRC_URI="http://jdolan.dyndns.org/jaydolan/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

PDEPEND="media-video/mplayer"
RDEPEND="dev-python/pygtk"
DEPEND="sys-apps/sed"

src_compile() {
	emake || die "emake failed."
}

src_install() {
	emake PREFIX="/usr" DESTDIR="${D}" install || die "emake install failed."
	dodoc CHANGELOG README
	make_desktop_entry ${PN} "${PN}" ${PN}.png
}
