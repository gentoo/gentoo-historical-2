# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/xvattr/xvattr-1.3-r1.ebuild,v 1.14 2007/07/22 08:29:17 dberkholz Exp $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit eutils autotools

DESCRIPTION="X11 XVideo Querying/Setting Tool from Ogle project"
HOMEPAGE="http://www.dtek.chalmers.se/groups/dvd/"
SRC_URI="http://www.dtek.chalmers.se/groups/dvd/dist/${P}.tar.gz
	mirror://gentoo/${P}-nogtk.patch.bz2"

LICENSE="GPL-2"
SLOT=0
KEYWORDS="amd64 ppc x86"
IUSE="gtk"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXv
	x11-libs/libXext
	gtk? (
		=x11-libs/gtk+-1.2*
		=dev-libs/glib-1.2* )"

DEPEND="${RDEPEND}
	x11-libs/libXt"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${DISTDIR}/${P}-nogtk.patch.bz2"
	AT_M4DIR="${S}/m4" eautoreconf
}

src_compile() {
	econf $(use_with gtk) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS README
}
