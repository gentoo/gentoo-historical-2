# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/dragonplayer/dragonplayer-4.4.4.ebuild,v 1.1 2010/06/06 14:42:13 scarabeus Exp $

EAPI="3"

KMNAME="kdemultimedia"
inherit kde4-meta

DESCRIPTION="Dragon Player is a simple video player for KDE 4"
HOMEPAGE="http://www.dragonplayer.net/"

KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-2"
IUSE="debug +handbook"

RDEPEND="
	aqua? ( >=media-libs/xine-lib-1.1.9 )
	!aqua? ( >=media-libs/xine-lib-1.1.9[xcb] )
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"
