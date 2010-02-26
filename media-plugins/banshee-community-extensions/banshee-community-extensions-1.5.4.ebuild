# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/banshee-community-extensions/banshee-community-extensions-1.5.4.ebuild,v 1.1 2010/02/26 06:29:52 ford_prefect Exp $

EAPI=3

inherit base mono

DESCRIPTION="Community-developed plugins for the Banshee media player"
HOMEPAGE="http://banshee-project.org/"
SRC_URI="http://download.banshee-project.org/${PN}/${PV}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="lirc lyrics mirage"

DEPEND=">=dev-lang/mono-2.0
	>=media-sound/banshee-1.5.3
	>=gnome-base/gconf-2.0
	lyrics? (
		dev-dotnet/gconf-sharp:2
		>=dev-dotnet/webkit-sharp-0.2
	)
	mirage? (
		dev-libs/glib:2
		dev-db/sqlite:3
		sci-libs/fftw:3.0
		media-libs/libsamplerate
		>=media-libs/gstreamer-0.10.15
		>=media-libs/gst-plugins-base-0.10.15
	)"
RDEPEND="${DEPEND}
	!media-plugins/banshee-lyrics
	!media-plugins/banshee-mirage"

src_configure() {
	# Disable ClutterFlow as we don't have clutter in tree yet
	local myconf="--enable-gnome --disable-static --enable-release
		--with-gconf-schema-file-dir=/etc/gconf/schemas
		--with-vendor-build-id=Gentoo/${PN}/${PVR}
		--disable-clutterflow --enable-liveradio"

	econf \
		$(use_enable lirc) \
		$(use_enable lyrics) \
		$(use_enable mirage) \
		${myconf}
}

src_install() {
	base_src_install
}
