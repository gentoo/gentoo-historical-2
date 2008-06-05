# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/systemsettings/systemsettings-4.0.5.ebuild,v 1.1 2008/06/05 22:48:31 keytoaster Exp $

EAPI="1"

KMNAME=kdebase-workspace
OPENGL_REQUIRED="optional"
inherit kde4-meta

DESCRIPTION="System settings utility"
IUSE="debug htmlhandbook opengl +usb xinerama"
KEYWORDS="~amd64 ~x86"

COMMONDEPEND="
	>=app-misc/strigi-0.5.7
	>=dev-libs/glib-2
	media-libs/fontconfig
	>=media-libs/freetype-2
	>=x11-libs/libxklavier-3.2
	x11-libs/libXcursor
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXft
	>=x11-libs/libXrandr-1.2.1
	x11-libs/libXtst
	opengl? ( virtual/opengl )
	usb? ( >=dev-libs/libusb-0.1.10a )
	xinerama? ( x11-libs/libXinerama )"
DEPEND="${COMMONDEPEND}
	x11-proto/xextproto
	x11-proto/kbproto
	xinerama? ( x11-proto/xineramaproto )"
RDEPEND="${COMMONDEPEND}
	|| ( x11-misc/xkeyboard-config
		x11-misc/xkbdata )
	x11-apps/setxkbmap"

KMEXTRA="kcontrol/"

KMEXTRACTONLY="krunner/org.kde.krunner.App.xml
	krunner/org.kde.screensaver.xml
	kwin/
	libs/
	plasma/"

PATCHES="${FILESDIR}/${PN}-4.0.2-opengl.patch"

# FIXME: is have_openglxvisual found without screensaver
src_compile() {
	# Old keyboard-detection code is unmaintained,
	# so we force the new stuff, using libxklavier.
	mycmakeargs="${mycmakeargs}
		-DUSE_XKLAVIER=ON -DWITH_LibXKlavier=ON
		-DWITH_GLIB2=ON -DWITH_GObject=ON
		$(cmake-utils_use_with opengl OpenGL)
		$(cmake-utils_use_with usb USB)
		$(cmake-utils_use_with xinerama X11_Xinerama)"

	kde4-meta_src_compile
}
