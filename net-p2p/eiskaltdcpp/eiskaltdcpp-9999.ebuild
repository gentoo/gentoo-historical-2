# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/eiskaltdcpp/eiskaltdcpp-9999.ebuild,v 1.1 2010/04/26 17:00:22 pva Exp $

EAPI=2

LANGS="be en hu ru"
inherit qt4-r2 cmake-utils subversion

DESCRIPTION="Qt4 based client for DirectConnect and ADC protocols, based on DC++ library"
HOMEPAGE="http://eiskaltdc.googlecode.com/"
ESVN_REPO_URI="http://${PN%pp}.googlecode.com/svn/branches/trunk/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="spell"

RDEPEND="x11-libs/qt-gui:4
	x11-libs/qt-core:4
	x11-libs/qt-dbus:4
	dev-libs/openssl
	net-libs/libupnp
	dev-libs/boost
	app-arch/bzip2
	sys-libs/zlib
	spell? ( app-text/aspell )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_configure() {
	# linguas
	local langs
	for lang in ${LANGS}; do
		use linguas_${lang} && langs+="${lang} "
	done
	[[ -z ${langs} ]] && langs=${LANGS}

	local mycmakeargs=(
		"$(cmake-utils_use spell USE_ASPELL)"
		-Dlinguas="${langs}"
	)
	cmake-utils_src_configure
}
