# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/ktorrent/ktorrent-3.3_beta1.ebuild,v 1.2 2009/08/13 07:53:51 wired Exp $

EAPI="2"

if [[ ${PV} == *9999* ]] ; then
	KEYWORDS=""
	KMNAME="extragear/network"
else
	# upstream likes to skip that _ in beta releases
	MY_PV="${PV/_/}"
	MY_P="${PN}-${MY_PV}"
	KDE_LINGUAS="ar be bg ca cs da de el en_GB es et fr ga gl hi it ja
		km lt lv nb nds nl nn oc pl pt pt_BR ro ru se sk sl sr sv
		tr uk zh_CN zh_TW"
	KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
	SRC_URI="http://ktorrent.org/downloads/${MY_PV}/${MY_P}.tar.bz2"
	S="${WORKDIR}"/"${MY_P}"
fi

inherit kde4-base

DESCRIPTION="A BitTorrent program for KDE."
HOMEPAGE="http://ktorrent.org/"

LICENSE="GPL-2"
SLOT="4"
IUSE="+bwscheduler debug +downloadorder +infowidget +ipfilter +kross +logviewer
+mediaplayer plasma rss +scanfolder +search +shutdown +stats +upnp webinterface +zeroconf"

COMMONDEPEND="
	app-crypt/qca:2
	dev-libs/gmp
	mediaplayer? ( >=media-libs/taglib-1.5 )
	plasma? ( >=kde-base/libtaskmanager-${KDE_MINIMAL} )
	rss? (
		dev-libs/boost
		>=kde-base/kdepimlibs-${KDE_MINIMAL}
	)
"
DEPEND="${COMMONDEPEND}
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
	mycmakeargs="${mycmakeargs}
		-DENABLE_DHT_SUPPORT=ON
		-DWITH_SYSTEM_GEOIP=ON
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
		$(cmake-utils_use_enable shutdown SHUTDOWN_PLUGIN)
		$(cmake-utils_use_enable stats STATS_PLUGIN)
		$(cmake-utils_use_enable upnp UPNP_PLUGIN)
		$(cmake-utils_use_enable webinterface WEBINTERFACE_PLUGIN)
		$(cmake-utils_use_enable zeroconf ZEROCONF_PLUGIN)"
	kde4-base_src_configure
}
