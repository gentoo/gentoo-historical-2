# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/leechcraft-poshuku/leechcraft-poshuku-0.5.70.ebuild,v 1.1 2012/05/31 21:10:40 maksbotan Exp $

EAPI="4"

inherit confutils leechcraft

DESCRIPTION="Poshuku, the full-featured web browser plugin for LeechCraft."

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +cleanweb +fatape +filescheme +fua +idn +keywords +onlinebookmarks
		wyfv +sqlite postgres pogooglue"

DEPEND="~net-misc/leechcraft-core-${PV}[postgres?,sqlite?]
		x11-libs/qt-webkit
		onlinebookmarks? ( >=dev-libs/qjson-0.7.1-r1 )
		idn? ( net-dns/libidn )"
RDEPEND="${DEPEND}
		virtual/leechcraft-downloader-http"

pkg_setup() {
	confutils_require_any postgres sqlite
}

src_configure() {
	local mycmakeargs="
		$(cmake-utils_use_enable cleanweb POSHUKU_CLEANWEB)
		$(cmake-utils_use_enable fatape POSHUKU_FATAPE)
		$(cmake-utils_use_enable filescheme POSHUKU_FILESCHEME)
		$(cmake-utils_use_enable fua POSHUKU_FUA)
		$(cmake-utils_use_enable idn IDN)
		$(cmake-utils_use_enable keywords POSHUKU_KEYWORDS)
		$(cmake-utils_use_enable onlinebookmarks POSHUKU_ONLINEBOOKMARKS)
		$(cmake-utils_use_enable pogooglue POSHUKU_POGOOGLUE)
		$(cmake-utils_use_enable wyfv POSHUKU_WYFV)
		"

	cmake-utils_src_configure
}
