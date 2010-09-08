# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/cairo/cairo-1.10.0.ebuild,v 1.1 2010/09/08 16:03:11 cardoe Exp $

EAPI=2

inherit eutils flag-o-matic autotools

DESCRIPTION="A vector graphics library with cross-device output support"
HOMEPAGE="http://cairographics.org/"
SRC_URI="http://cairographics.org/releases/${P}.tar.gz"

LICENSE="|| ( LGPL-2.1 MPL-1.1 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="aqua debug directfb doc drm gallium opengl openvg qt +svg X xcb"

# Test causes a circular depend on gtk+... since gtk+ needs cairo but test needs gtk+ so we need to block it
RESTRICT="test"

RDEPEND=">=media-libs/fontconfig-2.2.95
	>=media-libs/freetype-2.1.9
	sys-libs/zlib
	>=media-libs/libpng-1.2.43-r2:0
	>=x11-libs/pixman-0.18.4
	directfb? ( >=dev-libs/DirectFB-0.9.24 )
	gallium? ( media-libs/mesa[gallium] )
	qt? ( >=x11-libs/qt-gui-4.4:4 )
	svg? ( dev-libs/libxml2 )
	X? ( >=x11-libs/libXrender-0.6
		x11-libs/libXext
		x11-libs/libX11
		x11-libs/libXft 
		drm? ( >=sys-fs/udev-136
		>=x11-base/xorg-server-1.6 )
		)
	xcb? (	>=x11-libs/libxcb-1.4
		x11-libs/xcb-util )"
#	test? (
#	pdf test
#	x11-libs/pango
#	>=x11-libs/gtk+-2.0
#	>=app-text/poppler-bindings-0.9.2[gtk]
#	ps test
#	app-text/ghostscript-gpl
#	svg test
#	>=x11-libs/gtk+-2.0
#	>=gnome-base/librsvg-2.15.0

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.19
	>=sys-devel/libtool-2
	doc? (	>=dev-util/gtk-doc-1.6
		~app-text/docbook-xml-dtd-4.2 )
	X? ( x11-proto/renderproto
		drm? ( x11-proto/xproto
		>=x11-proto/xextproto-7.1 )
		)"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.8.8-interix.patch

	# We need to run elibtoolize to ensure correct so versioning on FreeBSD
	# upgraded to an eautoreconf for the above interix patch.
	eautoreconf
}

src_configure() {
	[[ ${CHOST} == *-interix* ]] && append-flags -D_REENTRANT
	# http://bugs.freedesktop.org/show_bug.cgi?id=15463
	[[ ${CHOST} == *-solaris* ]] && append-flags -D_POSIX_PTHREAD_SEMANTICS

	#gets rid of fbmmx.c inlining warnings
	append-flags -finline-limit=1200

	econf \
		$(use_enable X xlib) \
		$(use_enable X xlib-xrender) \
		$(use_enable xcb) \
		$(use_enable svg) \
		$(use_enable doc gtk-doc) \
		$(use_enable directfb) \
		$(use_enable debug test-surfaces) \
		$(use_enable opengl gl) \
		$(use_enable openvg vg) \
		$(use_enable drm) \
		$(use_enable gallium) \
		--enable-pdf \
		--enable-png \
		--enable-ft \
		--enable-ps \
		$(use_enable aqua quartz) \
		$(use_enable aqua quartz-image) \
		$(use_enable aqua quartz-font) \
		|| die "configure failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Installation failed"
	dodoc AUTHORS ChangeLog NEWS README
}

pkg_postinst() {
	if use xcb; then
		ewarn "You have enabled the Cairo XCB backend which is used only by"
		ewarn "a select few apps. The Cairo XCB backend is presently"
		ewarn "un-maintained and needs a lot of work to get it caught up"
		ewarn "to the Xrender and Xlib backends, which are the backends used"
		ewarn "by most applications. See:"
		ewarn "http://lists.freedesktop.org/archives/xcb/2008-December/004139.html"
	fi
}
