# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/liteamp/liteamp-0.2.3.2.ebuild,v 1.6 2004/06/25 00:09:02 agriffis Exp $

IUSE=""

inherit eutils gnome2

DESCRIPTION="Liteamp - yet another light-weight ogg and mp3 player for gnome"
SRC_URI="http://download.kldp.net/liteamp/${P}.tar.gz"
HOMEPAGE="http://liteamp.kldp.net"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"

DEPEND=">=x11-libs/gtk+-2.0.0
	>=gnome-base/libgnomeui-2.0
	>=media-libs/libvorbis-1.0
	>=media-sound/madplay-0.14.2b
	media-libs/libao
	media-libs/libogg"

DOC="AUTHORS COPYING ChangeLog INSTALL NEWS README"
