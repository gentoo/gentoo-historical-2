# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/gegl/gegl-0.1.6.ebuild,v 1.1 2011/02/15 23:40:34 hanno Exp $

EAPI="2"

inherit eutils autotools

DESCRIPTION="A graph based image processing framework"
HOMEPAGE="http://www.gegl.org/"
SRC_URI="ftp://ftp.gimp.org/pub/${PN}/${PV:0:3}/${P}.tar.bz2"

LICENSE="|| ( GPL-3 LGPL-3 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"

IUSE="cairo debug doc ffmpeg jpeg mmx openexr png raw sdl sse svg v4l"

DEPEND=">=media-libs/babl-0.1.2
	>=dev-libs/glib-2.22.0
	media-libs/libpng
	>=x11-libs/gtk+-2.18.0
	x11-libs/pango
	cairo? ( x11-libs/cairo )
	doc? ( app-text/asciidoc
		dev-lang/ruby
		>=dev-lang/lua-5.1.0
		app-text/enscript
		media-gfx/graphviz
		|| ( media-gfx/imagemagick[png] media-gfx/graphicsmagic[png] ) )
	ffmpeg? ( >=media-video/ffmpeg-0.4.9_p20080326 )
	jpeg? ( virtual/jpeg )
	openexr? ( media-libs/openexr )
	raw? ( >=media-libs/libopenraw-0.0.5 )
	sdl? ( media-libs/libsdl )
	svg? ( >=gnome-base/librsvg-2.14.0 )"
RDEPEND="${DEPEND}"

# broken upstream, see:
# https://bugzilla.gnome.org/show_bug.cgi?id=642390
RESTRICT="test"

src_prepare() {
	# fix OSX loadable module filename extension
	sed -i -e 's/\.dylib/.bundle/' configure.ac || die
	eautoreconf
}

src_configure() {
	econf --with-gtk --with-pango --with-gdk-pixbuf \
		$(use_enable debug) \
		$(use_with cairo) \
		$(use_with cairo pangocairo) \
		$(use_with v4l libv4l) \
		$(use_enable doc docs) \
		$(use_with doc graphviz) \
		$(use_with doc lua) \
		$(use_enable doc workshop) \
		$(use_with ffmpeg libavformat) \
		$(use_with jpeg libjpeg) \
		$(use_enable mmx) \
		$(use_with openexr) \
		$(use_with png libpng) \
		$(use_with raw libopenraw) \
		$(use_with sdl) \
		$(use_with svg librsvg) \
		$(use_enable sse)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	find "${D}" -name '*.la' -delete
	dodoc ChangeLog INSTALL README NEWS || die "dodoc failed"
}
