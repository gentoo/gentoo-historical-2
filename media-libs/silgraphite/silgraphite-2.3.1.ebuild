# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/silgraphite/silgraphite-2.3.1.ebuild,v 1.11 2010/03/10 10:01:52 josejx Exp $

EAPI="2"

DESCRIPTION="Rendering engine for complex non-Roman writing systems"
HOMEPAGE="http://graphite.sil.org/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}.tar.gz"

LICENSE="|| ( CPL-0.5 LGPL-2.1 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sh ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="pango truetype xft"

RDEPEND="xft? ( x11-libs/libXft )
	truetype? ( media-libs/freetype:2 )
	pango? ( x11-libs/pango media-libs/fontconfig )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_configure() {
	econf \
		$(use_with xft) \
		$(use_with truetype freetype) \
		$(use_with pango pangographite)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README
}
