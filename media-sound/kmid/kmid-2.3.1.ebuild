# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/kmid/kmid-2.3.1.ebuild,v 1.1 2010/06/13 10:10:50 ssuominen Exp $

EAPI=2
# fix linguas.desc, sr@ijekavianlatin sr@ijekavian
KDE_LINGUAS="ca ca@valencia cs da de en_GB es fr gl nb nl pt_BR pt sr@Latn sr
sv uk zh_CN"
inherit kde4-base

DESCRIPTION="a MIDI/Karaoke player for KDE"
HOMEPAGE="http://userbase.kde.org/KMid2"
SRC_URI="mirror://sourceforge/kmid2/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug +handbook"

DEPEND="media-libs/alsa-lib
	media-sound/drumstick"

DOCS="ChangeLog README TODO"
