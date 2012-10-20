# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/ettercap/ettercap-0.7.5_p20121020.ebuild,v 1.1 2012/10/20 11:23:10 ago Exp $

EAPI=4

CMAKE_MIN_VERSION=2.8

inherit cmake-utils

DESCRIPTION="A suite for man in the middle attacks"
HOMEPAGE="http://ettercap.sourceforge.net https://github.com/Ettercap/ettercap"
SRC_URI="http://dev.gentoo.org/~ago/distfiles/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="gtk ipv6 ncurses +plugins ssl"

RDEPEND="dev-libs/libpcre
	net-libs/libnet:1.1
	>=net-libs/libpcap-0.8.1
	sys-libs/zlib
	gtk? (
		>=dev-libs/atk-1.2.4
		>=dev-libs/glib-2.2.2:2
		media-libs/freetype
		x11-libs/cairo
		x11-libs/gdk-pixbuf:2
		>=x11-libs/gtk+-2.2.2:2
		>=x11-libs/pango-1.2.3
	)
	ncurses? ( >=sys-libs/ncurses-5.3 )
	plugins? (
		>=net-misc/curl-7.26.0
		sys-devel/libtool
	)
	ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}
	app-text/ghostscript-gpl
	sys-devel/flex
	virtual/yacc"

src_prepare() {
	#ettercap defaults to using mozilla so let's try to use xdg-open and pray it works
	sed -i 's#mozilla -remote openurl(http://%host%url)#xdg-open 'http://%host%url'#' \
	share/etter.conf || die
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable ncurses CURSES)
		$(cmake-utils_use_enable gtk)
		$(cmake-utils_use_enable ssl)
		$(cmake-utils_use_enable plugins)
		$(cmake-utils_use_enable ipv6)
	)
	cmake-utils_src_configure
}
