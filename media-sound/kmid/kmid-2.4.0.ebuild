# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/kmid/kmid-2.4.0.ebuild,v 1.1 2010/10/29 13:58:32 ssuominen Exp $

EAPI=2
KDE_LINGUAS="ca ca@valencia cs da de en_GB es fr gl nb nl pt_BR pt
sr@ijekavianlatin sr@ijekavian sr@Latn sr sv tr uk zh_CN"
inherit kde4-base

DESCRIPTION="a MIDI/Karaoke player for KDE"
HOMEPAGE="http://userbase.kde.org/KMid2"
SRC_URI="mirror://sourceforge/kmid2/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug +handbook"

RDEPEND="media-libs/alsa-lib
	>=media-sound/drumstick-0.4"
DEPEND="${RDEPEND}"

DOCS="ChangeLog README TODO"
