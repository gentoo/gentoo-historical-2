# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/kplayer/kplayer-0.7.ebuild,v 1.3 2009/02/27 12:35:32 scarabeus Exp $

EAPI="2"

KDE_LINGUAS="be br ca cs cy da de el en_GB es et eu fi fr ga gl he hu it ja nb
	nds nl oc pa pl pt pt_BR ru sr sv tr zh_CN"
inherit kde4-base

DESCRIPTION="KPlayer is a KDE media player based on mplayer."
HOMEPAGE="http://kplayer.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0.7"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="!kdeprefix? ( !media-video/kplayer:0 )"
RDEPEND="${DEPEND}
	>=media-video/mplayer-1.0_rc1"

CMAKE_IN_SOURCE_BUILD="1"

src_prepare() {
	# doc not working
	sed -i \
		-e "s:set(CMAKE_VERBOSE_MAKEFILE ON):#nada:g" \
		-e "s:add_subdirectory(doc):#nada:g" \
		"${S}"/CMakeLists.txt

	# linking against X11 libraries
	sed -i "s:target_link_libraries(kplayerpart :target_link_libraries(kplayerpart \${X11_LIBRARIES} :" \
		"${S}"/kplayer/CMakeLists.txt

	kde4-base_src_prepare
}
