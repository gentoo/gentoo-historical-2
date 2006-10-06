# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/evince/evince-0.5.5.ebuild,v 1.2 2006/10/06 14:26:27 dang Exp $

inherit eutils gnome2

DESCRIPTION="Simple document viewer for GNOME"
HOMEPAGE="http://www.gnome.org/projects/evince/"
LICENSE="GPL-2"

# TODO: Use 'gnome' flag instead of 'nautilus'
IUSE="dbus djvu doc dvi nautilus t1lib tiff"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	dvi? (
		virtual/tetex
		t1lib? ( >=media-libs/t1lib-5.0.0 )
	)
	dbus? ( >=sys-apps/dbus-0.33 )
	tiff? ( >=media-libs/tiff-3.6 )
	>=app-text/poppler-bindings-0.5.2
	>=dev-libs/glib-2
	>=gnome-base/gnome-vfs-2.0
	>=gnome-base/libglade-2
	>=gnome-base/gconf-2
	gnome-base/libgnome
	>=gnome-base/libgnomeprintui-2.6
	>=gnome-base/libgnomeui-2.14
	nautilus? ( >=gnome-base/nautilus-2.10 )
	>=x11-libs/gtk+-2.8.15
	gnome-base/gnome-keyring
	djvu? ( >=app-text/djvu-3.5.17 )
	virtual/ghostscript"

DEPEND="${RDEPEND}
	app-text/scrollkeeper
	>=app-text/gnome-doc-utils-0.3.2
	>=dev-util/pkgconfig-0.9
	>=sys-devel/automake-1.9
	>=dev-util/intltool-0.35"


DOCS="AUTHORS ChangeLog NEWS README TODO"
USE_DESTDIR="1"
ELTCONF="--portage"


pkg_setup() {
	G2CONF="--disable-scrollkeeper \
		--enable-comics		\
		--enable-impress	\
		$(use_enable dbus)  \
		$(use_enable djvu)  \
		$(use_enable dvi)   \
		$(use_enable t1lib) \
		$(use_enable tiff)  \
		$(use_enable nautilus)"

	if ! built_with_use app-text/poppler-bindings gtk; then
		einfo "Please re-emerge app-text/poppler-bindings with the gtk USE flag set"
		die "poppler-bindings needs gtk flag set"
	fi
}

src_unpack(){
	unpack "${A}"
	cd "${S}"

	# Fix .desktop file so menu item shows up
	epatch ${FILESDIR}/${PN}-0.5.3-display-menu.patch
}
