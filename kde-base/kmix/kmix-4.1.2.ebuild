# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kmix/kmix-4.1.2.ebuild,v 1.1 2008/10/02 09:11:40 jmbsvicetto Exp $

EAPI="2"

KMNAME=kdemultimedia
inherit kde4-meta

DESCRIPTION="KDE mixer gui"
KEYWORDS="~amd64 ~x86"
IUSE="alsa debug htmlhandbook"

DEPEND="
	media-sound/phonon
	alsa? ( >=media-libs/alsa-lib-1.0.14a )"
RDEPEND="${DEPEND}"

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with alsa Alsa)"
	kde4-meta_src_configure
}
