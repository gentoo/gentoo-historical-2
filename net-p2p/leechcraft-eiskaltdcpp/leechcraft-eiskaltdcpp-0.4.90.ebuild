# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/leechcraft-eiskaltdcpp/leechcraft-eiskaltdcpp-0.4.90.ebuild,v 1.1 2011/09/15 12:48:40 maksbotan Exp $

EAPI="2"

inherit leechcraft

DESCRIPTION="EiskaltDC++ ported to LeechCraft."

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +emoticons examples javascript lua pcre spell sqlite upnp"

RDEPEND="=net-misc/leechcraft-core-${PV}
		app-arch/bzip2
		sys-libs/zlib
		>=dev-libs/openssl-0.9.8
		virtual/libiconv
		sys-devel/gettext
		lua? ( >=dev-lang/lua-5.1 )
		upnp? ( net-libs/miniupnpc )
		javascript? (
			x11-libs/qt-script
			x11-libs/qtscriptgenerator
		)
		spell? ( app-text/aspell )
		sqlite? ( x11-libs/qt-sql:4[sqlite] )
		pcre? ( >=dev-libs/libpcre-4.2 )
		virtual/leechcraft-task-show"
DEPEND="=net-misc/leechcraft-core-${PV}
		dev-util/pkgconfig"

src_configure() {
	local mycmakeargs=(
		"$(cmake-utils_use lua LUA_SCRIPT)"
		"$(cmake-utils_use lua WITH_LUASCRIPTS)"
		"$(cmake-utils_use javascript USE_JS)"
		"$(cmake-utils_use spell USE_ASPELL)"
		"$(cmake-utils_use sqlite USE_QT_SQLITE)"
		"$(cmake-utils_use upnp USE_MINIUPNP)"
		-DLOCAL_MINIUPNP="0"
		"$(cmake-utils_use emoticons WITH_EMOTICONS)"
		"$(cmake-utils_use examples WITH_EXAMPLES)"
		"$(cmake-utils_use pcre PERL_REGEX)"
	)

	cmake-utils_src_configure
}
