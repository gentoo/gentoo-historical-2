# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/leechcraft-azoth/leechcraft-azoth-0.5.0.ebuild,v 1.3 2012/07/15 16:05:12 kensington Exp $

EAPI="4"

inherit leechcraft

DESCRIPTION="Azoth, the modular IM client for LeechCraft."

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +acetamide +adiumstyles +autoidler +autopaste +chathistory +crypt
		+depester +embedmedia +herbicide +hili +isterique +juick +lastseen
		+metacontacts +modnok +nativeemoticons +otroid +p100q +rosenthal
		+standardstyles +xoox +xtazy"

DEPEND="~net-misc/leechcraft-core-${PV}
		x11-libs/qt-webkit:4
		x11-libs/qt-multimedia:4
		autoidler? ( x11-libs/libXScrnSaver )
		otroid? ( net-libs/libotr )
		xoox? ( net-libs/qxmpp[extras] media-libs/speex )
		xtazy? ( x11-libs/qt-dbus:4 )
		crypt? ( app-crypt/qca app-crypt/qca-gnupg )"
RDEPEND="${DEPEND}
	modnok? (
		|| (
			media-gfx/imagemagick
			media-gfx/graphicsmagick[imagemagick]
		)
		virtual/latex-base
	)"

src_configure() {
	local mycmakeargs="
		$(cmake-utils_use_enable crypt CRYPT)
		$(cmake-utils_use_enable acetamide AZOTH_ACETAMIDE)
		$(cmake-utils_use_enable adiumstyles AZOTH_ADIUMSTYLES)
		$(cmake-utils_use_enable autoidler AZOTH_AUTOIDLER)
		$(cmake-utils_use_enable autopaste AZOTH_AUTOPASTE)
		$(cmake-utils_use_enable chathistory AZOTH_CHATHISTORY)
		$(cmake-utils_use_enable depester AZOTH_DEPESTER)
		$(cmake-utils_use_enable embedmedia AZOTH_EMBEDMEDIA)
		$(cmake-utils_use_enable herbicide AZOTH_HERBICIDE)
		$(cmake-utils_use_enable hili AZOTH_HILI)
		$(cmake-utils_use_enable isterique AZOTH_ISTERIQUE)
		$(cmake-utils_use_enable juick AZOTH_JUICK)
		$(cmake-utils_use_enable lastseen AZOTH_LASTSEEN)
		$(cmake-utils_use_enable metacontacts AZOTH_LASTSEEN)
		$(cmake-utils_use_enable modnok AZOTH_MODNOK)
		$(cmake-utils_use_enable nativeemoticons AZOTH_NATIVEEMOTICONS)
		$(cmake-utils_use_enable otroid AZOTH_OTROID)
		$(cmake-utils_use_enable p100q AZOTH_P100Q)
		$(cmake-utils_use_enable rosenthal AZOTH_ROSENTHAL)
		$(cmake-utils_use_enable standardstyles AZOTH_STANDARDSTYLES)
		$(cmake-utils_use_enable xoox AZOTH_XOOX)
		$(cmake-utils_use_enable xtazy AZOTH_XTAZY)"

	cmake-utils_src_configure
}

pkg_postinst() {
	if use rosenthal; then
		elog "You have enabled the Azoth Rosenthal plugin for"
		elog "spellchecking. It uses Hunspell/Myspell dictionaries,"
		elog "so install the ones for languages you use to enable"
		elog "spellchecking."
	fi
}
