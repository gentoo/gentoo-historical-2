# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/juk/juk-4.0.0.ebuild,v 1.1 2008/01/17 23:30:51 philantrop Exp $

EAPI="1"

KMNAME=kdemultimedia
inherit kde4-meta

DESCRIPTION="Jukebox and music manager for KDE."
KEYWORDS="~amd64 ~x86"
IUSE="debug htmlhandbook tunepimp"

DEPEND="
	media-libs/taglib
	tunepimp? ( media-libs/tunepimp )"
RDEPEND="${DEPEND}"

src_compile() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with tunepimp TunePimp)"
	kde4-meta_src_compile
}
