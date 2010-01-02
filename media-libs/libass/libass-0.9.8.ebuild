# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libass/libass-0.9.8.ebuild,v 1.3 2010/01/02 14:08:28 fauli Exp $

EAPI=2

DESCRIPTION="Library for SSA/ASS subtitles rendering"
HOMEPAGE="http://code.google.com/p/libass/"
SRC_URI="http://libass.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE="enca +fontconfig png"

RDEPEND="fontconfig? ( >=media-libs/fontconfig-2.2.0 )
	>=media-libs/freetype-2.1.10
	png? ( >=media-libs/libpng-1.2.15 )
	virtual/libiconv
	enca? ( app-i18n/enca )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_configure() {
	econf \
		$(use_enable enca) \
		$(use_enable fontconfig) \
		$(use_enable png)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc Changelog
}
