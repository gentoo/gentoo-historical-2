# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/kmid/kmid-2.3.0-r1.ebuild,v 1.3 2010/06/13 10:22:27 ssuominen Exp $

EAPI=2
KDE_LINGUAS="ca ca@valencia cs da de en_GB es fr gl nb pt_BR pt
sr@ijekavianlatin sr@ijekavian sr@Latn sr sv uk"
inherit kde4-base

DESCRIPTION="a MIDI/Karaoke player for KDE"
HOMEPAGE="http://userbase.kde.org/KMid2"
SRC_URI="mirror://sourceforge/kmid2/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 ~x86"
IUSE="debug +handbook"

DEPEND="media-libs/alsa-lib
	media-sound/drumstick"

DOCS="ChangeLog README TODO"
