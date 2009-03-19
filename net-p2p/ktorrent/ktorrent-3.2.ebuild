# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/ktorrent/ktorrent-3.2.ebuild,v 1.4 2009/03/19 14:29:46 ranger Exp $

EAPI="2"

KDE_MINIMAL="4.2"
KDE_LINGUAS="ar be bg ca cs da de el en_GB es et fr ga gl hi it ja
	km lt lv nb nds nl nn oc pl pt pt_BR ro ru se sk sl sr sv
	tr uk zh_CN zh_TW"
inherit kde4-base

DESCRIPTION="A BitTorrent program for KDE."
HOMEPAGE="http://ktorrent.org/"
SRC_URI="http://ktorrent.org/downloads/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
SLOT="3"
IUSE="+bwscheduler debug +downloadorder +infowidget +ipfilter +kross +logviewer +mediaplayer plasma rss +scanfolder +search +stats +upnp webinterface +zeroconf"

DEPEND="app-crypt/qca:2
	dev-libs/gmp
	sys-devel/gettext
	!kdeprefix? ( !net-p2p/ktorrent:0 )
	plasma? ( >=kde-base/libtaskmanager-${KDE_MINIMAL}[kdeprefix=] )
	rss? (
		dev-libs/boost
		>=kde-base/kdepimlibs-${KDE_MINIMAL}[kdeprefix=] )"
RDEPEND="${DEPEND}
	infowidget? ( >=dev-libs/geoip-1.4.4 )
	ipfilter? ( >=kde-base/kdebase-kioslaves-${KDE_MINIMAL}[kdeprefix=] )"

src_prepare() {
	if ! use plasma; then
		sed -i -e 's/add_subdirectory([[:space:]]*plasma[[:space:]]*)//' \
		CMakeLists.txt || die "Failed to make plasmoid optional"
	fi

	kde4-base_src_prepare
}

src_configure() {
	mycmakeargs="${mycmakeargs}
		-DENABLE_DHT_SUPPORT=ON
		$(cmake-utils_use_enable bwscheduler BWSCHEDULER_PLUGIN)
		$(cmake-utils_use_enable downloadorder DOWNLOADORDER_PLUGIN)
		$(cmake-utils_use_enable infowidget INFOWIDGET_PLUGIN)
		$(cmake-utils_use_with infowidget SYSTEM_GEOIP)
		$(cmake-utils_use_enable ipfilter IPFILTER_PLUGIN)
		$(cmake-utils_use_enable kross SCRIPTING_PLUGIN)
		$(cmake-utils_use_enable logviewer LOGVIEWER_PLUGIN)
		$(cmake-utils_use_enable mediaplayer MEDIAPLAYER_PLUGIN)
		$(cmake-utils_use_enable rss SYNDICATION_PLUGIN)
		$(cmake-utils_use_enable scanfolder SCANFOLDER_PLUGIN)
		$(cmake-utils_use_enable search SEARCH_PLUGIN)
		$(cmake-utils_use_enable stats STATS_PLUGIN)
		$(cmake-utils_use_enable upnp UPNP_PLUGIN)
		$(cmake-utils_use_enable webinterface WEBINTERFACE_PLUGIN)
		$(cmake-utils_use_enable zeroconf ZEROCONF_PLUGIN)"
	kde4-base_src_configure
}
