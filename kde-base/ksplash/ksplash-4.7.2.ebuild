# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/ksplash/ksplash-4.7.2.ebuild,v 1.1 2011/10/06 18:11:01 alexxy Exp $

EAPI=4

KMNAME="kde-workspace"
inherit kde4-meta

DESCRIPTION="KDE splashscreen framework (the splashscreen of KDE itself, not of individual apps)"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="3dnow altivec debug mmx sse sse2 xinerama"

COMMONDEPEND="
	media-libs/libpng
	xinerama? ( x11-libs/libXinerama )
"
DEPEND="${COMMONDEPEND}
	xinerama? ( x11-proto/xineramaproto )
"
RDEPEND="${COMMONDEPEND}"

PATCHES=( "${FILESDIR}/${PN}-4.4.2-xinerama_cmake_automagic.patch" )

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_has 3dnow X86_3DNOW)
		$(cmake-utils_use_has altivec PPC_ALTIVEC)
		$(cmake-utils_use_has mmx X86_MMX)
		$(cmake-utils_use_has sse X86_SSE)
		$(cmake-utils_use_has sse2 X86_SSE2)
		$(cmake-utils_use_with xinerama X11_Xinerama)
	)

	kde4-meta_src_configure
}
