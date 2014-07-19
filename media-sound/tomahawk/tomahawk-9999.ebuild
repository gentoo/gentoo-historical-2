# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/tomahawk/tomahawk-9999.ebuild,v 1.26 2014/07/19 11:40:34 johu Exp $

EAPI=5

KDE_REQUIRED="optional"
inherit kde4-base ${GIT_ECLASS}

if [[ ${PV} != *9999* ]]; then
	SRC_URI="http://download.tomahawk-player.org/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
else
	GIT_ECLASS="git-r3"
	EGIT_REPO_URI="git://github.com/tomahawk-player/${PN}.git"
	KEYWORDS=""
fi

DESCRIPTION="Multi-source social music player"
HOMEPAGE="http://tomahawk-player.org/"

LICENSE="GPL-3 BSD"
SLOT="0"
IUSE="debug jabber kde qt5 telepathy"

REQUIRED_USE="telepathy? ( kde )"

DEPEND="
	app-crypt/qca:2
	>=dev-cpp/clucene-2.3.3.4
	>=dev-libs/boost-1.41
	dev-libs/qjson
	dev-libs/quazip
	dev-libs/qtkeychain
	>=media-libs/libechonest-2.2.0:=
	>=media-libs/liblastfm-1.0.1
	>=media-libs/phonon-4.5.0
	>=media-libs/taglib-1.6.0
	x11-libs/libX11
	jabber? ( >=net-libs/jreen-1.1.1 )
	!qt5? (
		>=dev-libs/libattica-0.4.0
		dev-qt/designer:4
		dev-qt/qtcore:4
		dev-qt/qtdbus:4
		dev-qt/qtgui:4
		dev-qt/qtsql:4[sqlite]
		dev-qt/qtsvg:4
		dev-qt/qtwebkit:4
	)
	qt5? (
		>=dev-libs/libattica-0.4.0[qt5]
		dev-qt/designer:5
		dev-qt/qtcore:5
		dev-qt/qtsvg:5
		dev-qt/qtwebkit:5
		dev-qt/qtwidgets:5
	)
	telepathy? ( net-libs/telepathy-qt )
"
RDEPEND="${DEPEND}
	app-crypt/qca-ossl
"

DOCS=( AUTHORS ChangeLog README.md )

src_configure() {
	local mycmakeargs=(
		-DWITH_CRASHREPORTER=OFF
		$(cmake-utils_use_with jabber Jreen)
		$(cmake-utils_use_with kde KDE4)
		$(cmake-utils_use_build !qt5 WITH_QT4)
		$(cmake-utils_use_with telepathy TelepathyQt)
	)

	if [[ ${PV} != *9999* ]]; then
		mycmakeargs+=( -DBUILD_RELEASE=ON )
	fi

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
}
