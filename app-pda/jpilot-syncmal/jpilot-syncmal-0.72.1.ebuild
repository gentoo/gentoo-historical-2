# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/jpilot-syncmal/jpilot-syncmal-0.72.1.ebuild,v 1.4 2004/07/09 21:18:19 mr_bones_ Exp $

DESCRIPTION="Syncmal plugin for jpilot"
SRC_URI="http://jasonday.home.att.net/code/syncmal/${P}.tar.gz"
HOMEPAGE="http://jasonday.home.att.net/code/syncmal/syncmal.html"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~alpha ~ppc"
IUSE="gtk2"

RDEPEND="gtk2? ( >=x11-libs/gtk+-2 )
	!gtk2? ( >=x11-libs/gtk+-1.2 )
	>=app-pda/jpilot-0.99.7-r1"
DEPEND="${RDEPEND}
	gtk2? ( dev-util/pkgconfig )"

src_compile() {
	econf $(use_enable gtk2) || die "configure failed"
	emake -j1 || die "make failed"
}

src_install() {
	make install DESTDIR=${D} || die
}
