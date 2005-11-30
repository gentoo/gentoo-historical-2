# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/gtorrentviewer/gtorrentviewer-0.2a.ebuild,v 1.1.1.1 2005/11/30 09:51:19 chriswhite Exp $

inherit eutils gnome2

MY_PN=${PN/gtorrentviewer/GTorrentViewer}
MY_P=${MY_PN}-${PV}

DESCRIPTION="A GTK2-based viewer and editor for BitTorrent meta files"
HOMEPAGE="http://gtorrentviewer.sourceforge.net/"
SRC_URI="mirror://sourceforge/gtorrentviewer/${MY_P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="~x86 amd64"
SLOT="0"
IUSE=""
S=${WORKDIR}/${MY_P}

DEPEND="net-misc/curl
	>=x11-libs/gtk+-2.4
	>=dev-libs/glib-2.4"

DOCS="AUTHORS ChangeLog INSTALL NEWS README"
