# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/openal/openal-1.5.304.ebuild,v 1.2 2008/11/10 06:32:53 jer Exp $

inherit eutils cmake-utils

MY_P="${PN}-soft-${PV}"

DESCRIPTION="A software implementation of the OpenAL 3D audio API"
HOMEPAGE="http://kcat.strangesoft.net/openal.html"
SRC_URI="http://kcat.strangesoft.net/openal-releases/${MY_P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE="alsa oss debug"

RDEPEND="alsa? ( media-libs/alsa-lib )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"
DOCS="alsoftrc.sample"

src_compile() {
	local mycmakeargs=""

	use alsa || mycmakeargs="${mycmakeargs} -DALSA=OFF"
	use oss || mycmakeargs="${mycmakeargs} -DOSS=OFF"
	use debug && mycmakeargs="${mycmakeargs} -DCMAKE_BUILD_TYPE=Debug"

	cmake-utils_src_compile
}

pkg_postinst() {
	einfo "If you have performance problems using this library, then"
	einfo "try add these lines to your ~/.alsoftrc config file:"
	einfo "[alsa]"
	einfo "mmap = off"
}
