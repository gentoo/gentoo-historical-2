# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/kmidimon/kmidimon-0.7.3.ebuild,v 1.1 2010/04/28 00:07:41 ssuominen Exp $

EAPI=2
# FIXME. Doesn't build with KDE_LINGUAS added.
# KDE_LINGUAS="cs es"
inherit kde4-base

DESCRIPTION="A MIDI monitor for ALSA sequencer"
HOMEPAGE="http://kmetronome.sourceforge.net/kmidimon/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug +handbook"

DEPEND="media-libs/alsa-lib
	media-sound/drumstick"

DOCS="AUTHORS ChangeLog NEWS README TODO"

src_configure() {
	mycmakeargs=(
		"-DSTATIC_DRUMSTICK=OFF"
		)

	kde4-base_src_configure
}
