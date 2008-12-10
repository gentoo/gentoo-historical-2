# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/ktorrent/ktorrent-3.1.5.ebuild,v 1.2 2008/12/10 12:26:24 scarabeus Exp $

EAPI="2"

NEED_KDE="4.1"
KDE_LINGUAS="ca cs da de el es et fr gl it ja lv nb nds nl nn pl pt pt_BR ru sv uk zh_CN zh_TW"
inherit kde4-base

DESCRIPTION="A BitTorrent program for KDE."
HOMEPAGE="http://ktorrent.org/"
SRC_URI="http://ktorrent.org/downloads/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="4.1"
IUSE="+bwscheduler +infowidget +ipfilter +logviewer +mediaplayer +scanfolder +search +stats +upnp webinterface"

DEPEND="app-crypt/qca:2
	dev-libs/gmp
	sys-devel/gettext
	!kdeprefix? ( !net-p2p/ktorrent:0 )"
RDEPEND="${DEPEND}
	infowidget? ( >=dev-libs/geoip-1.4.4 )"

src_configure() {
	local mycmakeargs

	mycmakeargs="${mycmakeargs}
		-DCMAKE_INSTALL_PREFIX=${PREFIX}
		-DENABLE_DHT_SUPPORT=ON
		$(cmake-utils_use_enable bwscheduler BWSCHEDULER_PLUGIN)
		$(cmake-utils_use_enable infowidget INFOWIDGET_PLUGIN)
		$(cmake-utils_use_with infowidget SYSTEM_GEOIP)
		$(cmake-utils_use_enable ipfilter IPFILTER_PLUGIN)
		$(cmake-utils_use_enable logviewer LOGVIEWER_PLUGIN)
		$(cmake-utils_use_enable scanfolder SCANFOLDER_PLUGIN)
		$(cmake-utils_use_enable search SEARCH_PLUGIN)
		$(cmake-utils_use_enable stats STATS_PLUGIN)
		$(cmake-utils_use_enable upnp UPNP_PLUGIN)
		$(cmake-utils_use_enable webinterface WEBINTERFACE_PLUGIN)
		$(cmake-utils_use_enable mediaplayer MEDIAPLAYER_PLUGIN)"
	kde4-base_src_configure
}
