# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/k3d/k3d-0.5.0.37-r1.ebuild,v 1.2 2006/02/18 20:23:26 vanquirius Exp $

inherit eutils

DESCRIPTION="A free 3D modeling, animation, and rendering system"
HOMEPAGE="http://k3d.sourceforge.net/"
SRC_URI="mirror://sourceforge/k3d/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="expat gnome graphviz imagemagick jpeg nls openexr plib png python svg tiff truetype xml2"

DEPEND="virtual/opengl
	virtual/glu
	dev-libs/boost
	expat? ( dev-libs/expat )
	xml2? ( dev-libs/libxml2 )
	!xml2? ( dev-libs/expat )
	truetype? ( >=media-libs/freetype-2 )
	gnome? ( gnome-base/libgnome )
	imagemagick? ( media-gfx/imagemagick )
	jpeg? ( media-libs/jpeg )
	dev-cpp/glibmm
	dev-cpp/gtkmm
	>=x11-libs/gtkglext-1.0.6-r3
	openexr? ( media-libs/openexr )
	plib? ( media-libs/plib )
	png? ( media-libs/libpng )
	python? ( >=dev-lang/python-2.3 )
	tiff? ( media-libs/tiff )
	=dev-libs/libsigc++-2.0*
	gnome-base/librsvg"

RDEPEND="${DEPEND}
	( || (
	( x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libICE
	x11-libs/libSM )
	virtual/x11 )
	)"

DEPEND="${DEPEND}
	( || (
	( media-libs/mesa )
	virtual/x11 )
	)"

src_unpack() {
	unpack ${A}
	# bug 112144
	epatch "${FILESDIR}"/${PN}-0.5.0.37-nls.patch
}

src_compile() {
	local myconf="--with-ngui"
	if use expat || ! use xml2 ; then
		myconf="--without-libxml2"
	else
		myconf="--with-libxml2"
	fi

	econf \
		$(use_enable nls) \
		--with-external-boost \
		$(use_with truetype freetype2) \
		$(use_with gnome) \
		$(use_with graphviz) \
		$(use_with imagemagick) \
		$(use_with jpeg) \
		$(use_with openexr) \
		$(use_with plib) \
		$(use_with png) \
		$(use_with python) \
		$(use_with svg svg-icons) \
		$(use_with tiff) \
		${myconf} \
		|| die
	emake || die
}

src_install() {
	make install DESTDIR="${D}" || die
	dodoc AUTHORS NEWS README TODO
	#missing dir
	dodir /usr/share/k3d/shaders/layered
	keepdir /usr/share/k3d/shaders/layered
}
