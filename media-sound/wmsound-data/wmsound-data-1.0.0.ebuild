# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/wmsound-data/wmsound-data-1.0.0.ebuild,v 1.4 2004/09/03 21:07:32 eradicator Exp $

IUSE=""

DESCRIPTION="A bunch of sounds for WindowMaker Sound Server"
SRC_URI="http://largo.windowmaker.org/files/worms2sounds.tar.gz
		http://largo.windowmaker.org/files/wmsdefault.tar.gz"
HOMEPAGE="http://largo.windowmaker.org/"

DEPEND=">=x11-wm/windowmaker-0.80.2-r2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc ~amd64 ~sparc"

S1=${WORKDIR}/Sounds
S2=${WORKDIR}/SoundSets

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	insinto /usr/share/WindowMaker/Defaults
	doins ${FILESDIR}/WMSound

	insinto /etc/X11/WindowMaker
	doins ${FILESDIR}/WMSound

	insinto /usr/share/WindowMaker/SoundSets
	doins ${FILESDIR}/wmsound-soundset

	insinto /usr/share/WindowMaker/SoundSets/Default
	doins ${FILESDIR}/wmsound-soundset

	cd ${S1}
	insinto /usr/share/WindowMaker/Sounds
	doins *.wav

	cd ${S2}
	insinto /usr/share/WindowMaker/SoundSets
	doins Worms2
}
