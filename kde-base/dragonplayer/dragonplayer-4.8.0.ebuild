# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/dragonplayer/dragonplayer-4.8.0.ebuild,v 1.1 2012/01/25 18:17:06 johu Exp $

EAPI=4

KDE_HANDBOOK="optional"
KMNAME="kdemultimedia"
inherit kde4-meta

DESCRIPTION="Dragon Player is a simple video player for KDE 4"
HOMEPAGE="http://www.dragonplayer.net/"

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-2"
IUSE="debug xine"

RDEPEND="
	>=media-libs/phonon-4.4.3
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"
