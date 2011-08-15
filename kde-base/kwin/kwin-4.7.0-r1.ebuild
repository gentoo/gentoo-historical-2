# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kwin/kwin-4.7.0-r1.ebuild,v 1.1 2011/08/15 15:03:04 dilfridge Exp $

EAPI=4

KMNAME="kde-workspace"
OPENGL_REQUIRED="optional"
inherit kde4-meta

DESCRIPTION="KDE window manager"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug gles +xcomposite xinerama"

COMMONDEPEND="
	$(add_kdebase_dep kephal)
	$(add_kdebase_dep libkworkspace)
	$(add_kdebase_dep liboxygenstyle)
	x11-libs/libXdamage
	x11-libs/libXfixes
	>=x11-libs/libXrandr-1.2.1
	x11-libs/libXrender
	opengl? ( >=media-libs/mesa-7.10 )
	gles? ( >=media-libs/mesa-7.10[egl(+),gles] )
	xcomposite? ( x11-libs/libXcomposite )
	xinerama? ( x11-libs/libXinerama )
"
DEPEND="${COMMONDEPEND}
	x11-proto/damageproto
	x11-proto/fixesproto
	x11-proto/randrproto
	x11-proto/renderproto
	xcomposite? ( x11-proto/compositeproto )
	xinerama? ( x11-proto/xineramaproto )
"
RDEPEND="${COMMONDEPEND}
	x11-apps/scripts
"

KMEXTRACTONLY="
	ksmserver/
	libs/kephal/
	libs/oxygen/
"

PATCHES=(
	"${FILESDIR}/${PN}-4.4.2-xinerama_cmake_automagic.patch"
	"${FILESDIR}/${PN}-4.7.0-xcomposite_cmake_automagic.patch"
)

# you can use just gles or opengl or none
REQUIRED_USE="opengl? ( !gles ) gles? ( !opengl )"

src_configure() {
	# FIXME Remove when activity API moved away from libkworkspace
	append-cppflags "-I${EPREFIX}/usr/include/kworkspace"

	mycmakeargs=(
		$(cmake-utils_use_with gles OpenGLES)
		$(cmake-utils_use gles KWIN_BUILD_WITH_OPENGLES)
		$(cmake-utils_use_with opengl OpenGL)
		$(cmake-utils_use_with xinerama X11_Xinerama)
		$(cmake-utils_use_with xcomposite X11_Xcomposite)
	)

	kde4-meta_src_configure
}
