# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kmix/kmix-4.4.5.ebuild,v 1.5 2010/08/09 17:33:56 scarabeus Exp $

EAPI="3"

KMNAME="kdemultimedia"
inherit kde4-meta

DESCRIPTION="KDE mixer gui"
KEYWORDS="amd64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="alsa debug +handbook pulseaudio"

DEPEND="
	alsa? ( >=media-libs/alsa-lib-1.0.14a )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.12 )
"
RDEPEND="${DEPEND}"

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with pulseaudio PulseAudio)
		$(cmake-utils_use_with alsa)
	)

	kde4-meta_src_configure
}
