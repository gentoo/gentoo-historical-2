# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/xmms-alsa/xmms-alsa-1.2.10.ebuild,v 1.2 2005/02/28 10:43:15 eradicator Exp $

IUSE=""
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 sparc x86"

DEPEND=">=media-sound/xmms-1.2.10
	>=media-libs/alsa-lib-0.9.0"

PLUGIN_PATH="Output/alsa"

M4_VER="1.0"

myconf="--enable-alsa"
inherit xmms-plugin
