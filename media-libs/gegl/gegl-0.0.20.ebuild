# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/gegl/gegl-0.0.20.ebuild,v 1.12 2008/12/11 21:16:37 klausman Exp $

WANT_AUTOCONF=latest

inherit eutils autotools

DESCRIPTION="A graph based image processing framework"
HOMEPAGE="http://www.gegl.org/"
SRC_URI="ftp://ftp.gimp.org/pub/${PN}/0.0/${P}.tar.bz2"

LICENSE="|| ( GPL-3 LGPL-3 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc64 ~x86"

IUSE="cairo debug doc ffmpeg jpeg mmx openexr png raw sdl sse svg v4l"

DEPEND=">=media-libs/babl-0.0.20
	>=dev-libs/glib-2.18.0
	media-libs/libpng
	>=x11-libs/gtk+-2.14.0
	x11-libs/pango
	cairo? ( x11-libs/cairo )
	doc? ( app-text/asciidoc
		dev-lang/ruby
		>=dev-lang/lua-5.1.0
		app-text/enscript
		media-gfx/graphviz
		media-gfx/imagemagick )
	ffmpeg? ( >=media-video/ffmpeg-0.4.9_p20080326 )
	jpeg? ( media-libs/jpeg )
	openexr? ( media-libs/openexr )
	raw? ( >=media-libs/libopenraw-0.0.5 )
	sdl? ( media-libs/libsdl )
	svg? ( >=gnome-base/librsvg-2.14.0 )"

pkg_setup() {
	if use doc && ! built_with_use 'media-gfx/imagemagick' 'png'; then
		eerror "You must build imagemagick with png support"
		die "media-gfx/imagemagick built without png"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	#HACK!GACK!HACK!
	#Interface name changed, we change with it.
	if has_version '>=media-video/ffmpeg-0.4.9_p20081014'
	then
		sed -i \
			-e 's:p->enc->error_resilience:p->enc->error_recognition:' \
			operations/external/ff-load.c || die "404"
	fi

	epatch "${FILESDIR}/gegl-20-configure-ac.patch" || die
	epatch "${FILESDIR}/gegl-0.0.18-newffmpeg.diff" || die

	eautoreconf
}

src_compile() {
	econf --enable-gtk --enable-pango --enable-gdkpixbuf \
		$(use_enable debug) \
		$(use_with cairo) \
		$(use_with v4l) \
		$(use_enable doc docs) \
		$(use_with doc asciidoc) \
		$(use_with doc enscript) \
		$(use_with doc graphviz) \
		$(use_with doc lua) \
		$(use_with doc ruby) \
		$(use_enable doc workshop) \
		$(use_with ffmpeg libavcodec) \
		$(use_with ffmpeg libavformat) \
		$(use_with jpeg libjpeg) \
		$(use_enable mmx) \
		$(use_with openexr) \
		$(use_with png libpng) \
		$(use_with raw libopenraw) \
		$(use_with sdl libsdl) \
		$(use_with svg librsvg) \
		$(use_enable sse) \
		|| die "econf failed"
	env GEGL_SWAP="${WORKDIR}" emake || die "emake failed"
}

src_install() {
	# emake install doesn't install anything
	einstall || die "einstall failed"
	find "${D}" -name '*.la' -delete
	dodoc ChangeLog INSTALL README NEWS || die "dodoc failed"

	# don't know why einstall omits this?!
	insinto "/usr/include/${PN}-0.0/${PN}/buffer/"
	doins "${WORKDIR}/${P}/${PN}"/buffer/*.h || die "doins buffer failed"
	insinto "/usr/include/${PN}-0.0/${PN}/module/"
	doins "${WORKDIR}/${P}/${PN}"/module/*.h || die "doins module failed"
}
