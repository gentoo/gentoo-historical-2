# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/focuswriter/focuswriter-1.4.0.ebuild,v 1.2 2012/11/14 16:33:49 ago Exp $

EAPI=4
PLOCALES="ca cs da de el en es es_MX fi fr hu it ja nl pl pt_BR pt ru sk sv uk zh_CN"
PLOCALE_BACKUP="en"
inherit qt4-r2 l10n

DESCRIPTION="A fullscreen and distraction-free word processor"
HOMEPAGE="http://gottcode.org/focuswriter/"
SRC_URI="http://gottcode.org/${PN}/${P}-src.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="debug"

RDEPEND="
	app-text/enchant
	dev-libs/libzip
	media-libs/sdl-mixer[wav]
	x11-libs/qt-core:4
	x11-libs/qt-gui:4
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

DOCS=( ChangeLog CREDITS README )

src_prepare() {
	l10n_for_each_disabled_locale_do rm_loc
}

src_configure() {
	eqmake4 PREFIX="${EPREFIX}/usr"
}

rm_loc() {
	sed -e "s|translations/${PN}_${1}.ts||"	-i ${PN}.pro || die 'sed failed'
	rm translations/${PN}_${1}.{ts,qm} || die "removing ${1} locale failed"
}
