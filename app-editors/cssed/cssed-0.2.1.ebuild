# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/cssed/cssed-0.2.1.ebuild,v 1.2 2004/06/24 21:52:17 agriffis Exp $

DESCRIPTION="CSSED a GTK2 application to help create and maintain CSS style sheets for web developing"
HOMEPAGE="http://cssed.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""
DEPEND=">=x11-libs/gtk+-2
		>=dev-libs/atk-1.4.0
		>=dev-libs/glib-2.2.3
		>=media-libs/fontconfig-2.2.0-r2
		virtual/x11
		>=x11-libs/pango-1.2.1-r1"

src_compile() {
	./configure --prefix=/usr
	emake || die
}

src_install() {
	einstall || die
}

