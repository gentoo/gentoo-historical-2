# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/fbdesk/fbdesk-1.2.1.ebuild,v 1.6 2006/01/30 19:21:44 robbat2 Exp $

DESCRIPTION="fluxbox-util application that creates and manage icons on your Fluxbox desktop"
HOMEPAGE="http://www.fluxbox.org/fbdesk/"
SRC_URI="http://www.fluxbox.org/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="x86 ppc ~sparc ia64 ~amd64"
IUSE="debug png"

RDEPEND="png? ( media-libs/libpng )
		|| ( ( x11-libs/libXpm x11-libs/libXft ) virtual/x11 )"
DEPEND="${RDEPEND}
		|| ( ( x11-proto/xextproto ) virtual/x11 )"

src_compile() {
	econf \
	    $(use_enable debug) \
	    $(use_enable png) || die "econf failed"

	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS COPYING ChangeLog README
}
