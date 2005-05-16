# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/xosd/xosd-2.2.14.ebuild,v 1.3 2005/05/16 11:11:47 lanius Exp $

inherit eutils

DESCRIPTION="Library for overlaying text/glyphs in X-Windows X-On-Screen-Display plus binary for sending text from command line"
HOMEPAGE="http://www.ignavus.net/"
SRC_URI="mirror://debian/pool/main/x/xosd/${PN}_${PV}.orig.tar.gz
	mirror://debian/pool/main/x/xosd/${PN}_${PV}-1.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="xinerama xmms bmp"

DEPEND="virtual/x11
	bmp? (
		media-sound/beep-media-player
	)
	xmms? (
		media-sound/xmms
		>=media-libs/gdk-pixbuf-0.22.0
	)"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-m4.patch
	epatch "${FILESDIR}"/2.2.8-xmms-trackpos.patch
	epatch "${DISTDIR}"/${PN}_${PV}-1.diff.gz
	epatch ${FILESDIR}/xosd-2.2.14-bmp-fixes.patch
	automake
	autoconf
}

src_compile() {
	econf \
		`use_enable xinerama` \
		`use_enable xmms new-xmms` \
		`use_enable bmp  new-bmp` || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS COPYING README TODO
}
