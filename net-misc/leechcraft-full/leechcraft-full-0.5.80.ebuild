# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/leechcraft-full/leechcraft-full-0.5.80.ebuild,v 1.1 2012/08/13 14:04:36 maksbotan Exp $

EAPI="4"

DESCRIPTION="Metapackage containing all ready-to-use LeechCraft plugins"
HOMEPAGE="http://leechcraft.org/"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3"
IUSE="kde"

RDEPEND="
		~app-editors/leechcraft-popishu-${PV}
		~app-text/leechcraft-monocle-${PV}
		~media-sound/leechcraft-lmp-${PV}
		~media-sound/leechcraft-lastfmscrobble-${PV}
		~net-analyzer/leechcraft-networkmonitor-${PV}
		~net-im/leechcraft-azoth-${PV}
		~net-misc/leechcraft-advancednotifications-${PV}
		kde? ( ~net-misc/leechcraft-anhero-${PV} )
		~net-misc/leechcraft-auscrie-${PV}
		~net-misc/leechcraft-core-${PV}
		~net-misc/leechcraft-cstp-${PV}
		~net-misc/leechcraft-dbusmanager-${PV}
		~net-misc/leechcraft-gacts-${PV}
		~net-misc/leechcraft-glance-${PV}
		~net-misc/leechcraft-historyholder-${PV}
		~net-misc/leechcraft-kinotify-${PV}
		~net-misc/leechcraft-knowhow-${PV}
		~net-misc/leechcraft-lackman-${PV}
		~net-misc/leechcraft-liznoo-${PV}
		~net-misc/leechcraft-newlife-${PV}
		~net-misc/leechcraft-netstoremanager-${PV}
		~net-misc/leechcraft-otlozhu-${PV}
		~net-misc/leechcraft-qrosp-${PV}
		~net-misc/leechcraft-pintab-${PV}
		~net-misc/leechcraft-secman-${PV}
		~net-misc/leechcraft-sidebar-${PV}
		~net-misc/leechcraft-summary-${PV}
		~net-misc/leechcraft-tabpp-${PV}
		~net-misc/leechcraft-tabslist-${PV}
		~net-misc/leechcraft-tabsessmanager-${PV}
		~net-news/leechcraft-aggregator-${PV}
		~net-p2p/leechcraft-bittorrent-${PV}
		~net-proxy/leechcraft-xproxy-${PV}
		~sys-fs/leechcraft-vrooby-${PV}
		~www-client/leechcraft-deadlyrics-${PV}
		~www-client/leechcraft-dolozhee-${PV}
		~www-client/leechcraft-poshuku-${PV}
		~www-client/leechcraft-vgrabber-${PV}
		~www-misc/leechcraft-seekthru-${PV}
		"
DEPEND=""
