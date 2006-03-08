# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/audacious-show/audacious-show-1.2.0.ebuild,v 1.1 2006/03/08 21:46:00 hansmi Exp $

DESCRIPTION="XChat plugin to control audacious and to show whatever you're
currently playing to others"
HOMEPAGE="http://nedudu.hu/?page_id=11"
SRC_URI="http://nedudu.hu/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="
	media-sound/audacious
	>=net-irc/xchat-2.4
"

src_compile() {
	emake || die "emake failed"
}

src_install() {
	mv audacious-show-1.2.0.so audacious-show.so
	insinto  ${ROOT}/usr/lib/xchat/plugins/
	doins audacious-show.so
}
