# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libxspf/libxspf-1.2.0.ebuild,v 1.2 2009/05/10 20:21:13 ssuominen Exp $

EAPI=2
inherit eutils

DESCRIPTION="Playlist handling library"
HOMEPAGE="http://libspiff.sourceforge.net"
SRC_URI="mirror://sourceforge/libspiff/${P}.tar.bz2"

LICENSE="BSD LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="doc test"

RDEPEND=">=dev-libs/uriparser-0.7.5
	>=dev-libs/expat-2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	test? ( >=dev-util/cpptest-1.1 )
	doc? ( >=app-doc/doxygen-1.5.8
		>=x11-libs/qt-assistant-4
		media-gfx/graphviz )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc44.patch
}

src_configure() {
	econf \
		--docdir=/usr/share/doc/${PF} \
		--disable-dependency-tracking \
		$(use_enable test) \
		$(use_enable doc)
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README THANKS
}
