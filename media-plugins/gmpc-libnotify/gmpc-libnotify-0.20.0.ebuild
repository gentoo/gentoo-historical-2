# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gmpc-libnotify/gmpc-libnotify-0.20.0.ebuild,v 1.6 2011/03/19 16:41:35 angelos Exp $

EAPI=3
inherit eutils

DESCRIPTION="This plugin sends an announcement to the notification daemon on song change"
HOMEPAGE="http://gmpc.wikia.com/wiki/GMPC_PLUGIN_LIBNOTIFY"
SRC_URI="mirror://sourceforge/musicpd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="nls"

RDEPEND=">=media-sound/gmpc-${PV}
	dev-libs/libxml2
	x11-libs/libnotify"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	nls? ( dev-util/intltool
		sys-devel/gettext )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-libnotify-0.7.patch
}

src_configure() {
	econf \
		$(use_enable nls) \
		--disable-dependency-tracking
}

src_install() {
	emake DESTDIR="${D}" install || die
	find "${ED}" -name "*.la" -delete || die
}
