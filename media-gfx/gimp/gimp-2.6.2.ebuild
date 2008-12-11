# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gimp/gimp-2.6.2.ebuild,v 1.3 2008/12/11 21:17:53 klausman Exp $

inherit eutils gnome2 fdo-mime multilib python

DESCRIPTION="GNU Image Manipulation Program"
HOMEPAGE="http://www.gimp.org/"
SRC_URI="mirror://gimp/v2.6/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~x86"

IUSE="alsa aalib altivec curl dbus debug doc exif gnome hal jpeg lcms mmx mng pdf png python smp sse svg tiff webkit wmf"

RDEPEND=">=dev-libs/glib-2.18.1
	>=x11-libs/gtk+-2.12.5
	>=x11-libs/pango-1.18.0
	>=media-libs/freetype-2.1.7
	>=media-libs/fontconfig-2.2.0
	>=media-libs/libart_lgpl-2.3.8-r1
	sys-libs/zlib
	dev-libs/libxml2
	dev-libs/libxslt
	x11-misc/xdg-utils
	x11-themes/hicolor-icon-theme
	media-libs/gegl
	aalib? ( media-libs/aalib )
	alsa? ( >=media-libs/alsa-lib-1.0.14a-r1 )
	curl? ( net-misc/curl )
	dbus? ( dev-libs/dbus-glib )
	hal? ( sys-apps/hal )
	gnome? ( gnome-base/gvfs
		>=gnome-base/libgnomeui-2.10.0
		>=gnome-base/gnome-keyring-0.4.5 )
	webkit? ( net-libs/webkit-gtk )
	jpeg? ( >=media-libs/jpeg-6b-r2 )
	exif? ( >=media-libs/libexif-0.6.15 )
	lcms? ( media-libs/lcms )
	mng? ( media-libs/libmng )
	pdf? ( >=app-text/poppler-bindings-0.3.1 )
	png? ( >=media-libs/libpng-1.2.2 )
	python?	( >=dev-lang/python-2.5.0
		>=dev-python/pygtk-2.10.4 )
	tiff? ( >=media-libs/tiff-3.5.7 )
	svg? ( >=gnome-base/librsvg-2.8.0 )
	wmf? ( >=media-libs/libwmf-0.2.8 )"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.17
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog* HACKING NEWS README*"

pkg_setup() {
	if use pdf && ! built_with_use app-text/poppler-bindings gtk; then
		eerror "This package requires app-text/poppler-bindings compiled with GTK+ support."
		die "Please reemerge app-text/poppler-bindings with USE=\"gtk\"."
	fi
	if use alsa && ! built_with_use media-libs/alsa-lib midi; then
		eerror "This package requires media-libs/alsa-lib compiled with midi support."
		die "Please reemerge media-libs/alsa-lib with USE=\"midi\"."
	fi

	G2CONF="--enable-default-binary \
		--with-x \
		$(use_with aalib aa) \
		$(use_with alsa) \
		$(use_enable altivec) \
		$(use_with curl libcurl) \
		$(use_with dbus) \
		$(use_with hal) \
		$(use_with gnome gvfs) \
		--without-gnomevfs \
		$(use_with webkit) \
		$(use_with jpeg libjpeg) \
		$(use_with exif libexif) \
		$(use_with lcms) \
		$(use_enable mmx) \
		$(use_with mng libmng) \
		$(use_with pdf poppler) \
		$(use_with png libpng) \
		$(use_enable python) \
		$(use_enable smp mp) \
		$(use_enable sse) \
		$(use_with svg librsvg) \
		$(use_with tiff libtiff) \
		$(use_with wmf)"
}

pkg_postinst() {
	gnome2_pkg_postinst

	python_mod_optimize /usr/$(get_libdir)/gimp/2.0/python \
		/usr/$(get_libdir)/gimp/2.0/plug-ins
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup /usr/$(get_libdir)/gimp/2.0/python \
		/usr/$(get_libdir)/gimp/2.0/plug-ins
}
