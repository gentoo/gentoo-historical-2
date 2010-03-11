# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kmix/kmix-4.3.5.ebuild,v 1.3 2010/03/11 18:34:12 ranger Exp $

EAPI="2"

KMNAME="kdemultimedia"
inherit kde4-meta

DESCRIPTION="KDE mixer gui"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="alsa debug +handbook pulseaudio"

DEPEND="
	alsa? ( >=media-libs/alsa-lib-1.0.14a )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.12 )
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-4.3.2-solaris.patch )

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with pulseaudio PulseAudio)
		$(cmake-utils_use_with alsa)
	)

	kde4-meta_src_configure
}
