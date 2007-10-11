# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/fbdesk/fbdesk-1.2.1.ebuild,v 1.10 2007/10/11 18:13:08 lack Exp $

inherit eutils

DESCRIPTION="fluxbox-util application that creates and manage icons on your Fluxbox desktop"
HOMEPAGE="http://www.fluxbox.org/fbdesk/"
SRC_URI="http://www.fluxbox.org/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="x86 ppc ~sparc ia64 ~amd64"
IUSE="debug png"

RDEPEND="png? ( media-libs/libpng )
		x11-libs/libXpm
		x11-libs/libXft
		!>x11-wm/fluxbox-1.0_rc3_p4983"
DEPEND="${RDEPEND}
		x11-proto/xextproto"

src_unpack() {
	unpack ${A}

	cd "${S}"
	epatch "${FILESDIR}"/${P}-gcc41.patch
}

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
