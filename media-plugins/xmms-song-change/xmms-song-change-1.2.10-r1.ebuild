# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/xmms-song-change/xmms-song-change-1.2.10-r1.ebuild,v 1.2 2005/02/28 10:49:16 eradicator Exp $

IUSE=""
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 sparc x86"

DEPEND=">=media-sound/xmms-1.2.10"

PLUGIN_PATH="General/song_change"

PATCH_VER="2.2.2"
M4_VER="1.0"

inherit xmms-plugin
