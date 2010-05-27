# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/ktorrent/ktorrent-4.0.0.ebuild,v 1.1 2010/05/27 23:04:38 spatz Exp $

EAPI="2"

KDE_LINGUAS="ar be bg ca cs da de el en_GB es et eu fr ga gl hi hne hr hu is it
ja km lt lv mai ms nb nds nl nn oc pl pt pt_BR ro ru se sk sl sr sv tr uk zh_CN
zh_TW"

inherit kde4-base

DESCRIPTION="A BitTorrent program for KDE."
HOMEPAGE="http://ktorrent.org/"
SRC_URI="http://ktorrent.org/downloads/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
SLOT="4"
IUSE="+bwscheduler debug +downloadorder +infowidget +ipfilter +kross +logviewer
+magnetgenerator +mediaplayer plasma rss +scanfolder +search +shutdown +stats
+upnp webinterface +zeroconf"

COMMONDEPEND="
	>=net-libs/libktorrent-1.0_rc1
	mediaplayer? ( >=media-libs/taglib-1.5 )
	plasma? ( >=kde-base/libtaskmanager-${KDE_MINIMAL} )
	rss? (
		>=kde-base/kdepimlibs-${KDE_MINIMAL}
	)
	shutdown? (
		>=kde-base/solid-${KDE_MINIMAL}
		>=kde-base/libkworkspace-${KDE_MINIMAL}
	)
"
DEPEND="${COMMONDEPEND}
	dev-libs/boost
	sys-devel/gettext
"
RDEPEND="${COMMONDEPEND}
	infowidget? ( >=dev-libs/geoip-1.4.4 )
	ipfilter? (
		app-arch/bzip2
		app-arch/unzip
		>=kde-base/kdebase-kioslaves-${KDE_MINIMAL}
	)
	kross? ( >=kde-base/krosspython-${KDE_MINIMAL} )
"

src_prepare() {
	if ! use plasma; then
		sed -i \
			-e "s:add_subdirectory(plasma):#nada:g" \
			CMakeLists.txt || die "Failed to make plasmoid optional"
	fi

	kde4-base_src_prepare
}

src_configure() {
	mycmakeargs=(
		-DENABLE_DHT_SUPPORT=ON
		-DWITH_SYSTEM_GEOIP=ON
		$(cmake-utils_use_enable bwscheduler BWSCHEDULER_PLUGIN)
		$(cmake-utils_use_enable downloadorder DOWNLOADORDER_PLUGIN)
		$(cmake-utils_use_enable infowidget INFOWIDGET_PLUGIN)
		$(cmake-utils_use_with infowidget SYSTEM_GEOIP)
		$(cmake-utils_use_enable ipfilter IPFILTER_PLUGIN)
		$(cmake-utils_use_enable kross SCRIPTING_PLUGIN)
		$(cmake-utils_use_enable logviewer LOGVIEWER_PLUGIN)
		$(cmake-utils_use_enable magnetgenerator MAGNETGENERATOR_PLUGIN)
		$(cmake-utils_use_enable mediaplayer MEDIAPLAYER_PLUGIN)
		$(cmake-utils_use_enable rss SYNDICATION_PLUGIN)
		$(cmake-utils_use_enable scanfolder SCANFOLDER_PLUGIN)
		$(cmake-utils_use_enable search SEARCH_PLUGIN)
		$(cmake-utils_use_enable shutdown SHUTDOWN_PLUGIN)
		$(cmake-utils_use_enable stats STATS_PLUGIN)
		$(cmake-utils_use_enable upnp UPNP_PLUGIN)
		$(cmake-utils_use_enable webinterface WEBINTERFACE_PLUGIN)
		$(cmake-utils_use_enable zeroconf ZEROCONF_PLUGIN)
	)
	kde4-base_src_configure
}
