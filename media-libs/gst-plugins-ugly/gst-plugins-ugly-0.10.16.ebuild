# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/gst-plugins-ugly/gst-plugins-ugly-0.10.16.ebuild,v 1.7 2012/05/05 08:02:28 jdhore Exp $

# order is important, gnome2 after gst-plugins
inherit gst-plugins-ugly gst-plugins10 gnome2 eutils flag-o-matic libtool

DESCRIPTION="Basepack of plugins for gstreamer"
HOMEPAGE="http://gstreamer.sourceforge.net"
SRC_URI="http://gstreamer.freedesktop.org/src/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sh sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=media-libs/gst-plugins-base-0.10.26
	>=media-libs/gstreamer-0.10.26
	>=dev-libs/glib-2.20"
DEPEND="${RDEPEND}
	>=sys-devel/gettext-0.11.5
	virtual/pkgconfig
	!<media-libs/gst-plugins-bad-0.10.13"

GST_PLUGINS_BUILD=""

src_compile() {
	# gst doesnt handle optimisations well
	strip-flags
	replace-flags "-O3" "-O2"
	filter-flags "-fprefetch-loop-arrays" # see bug 22249

	gst-plugins-ugly_src_configure

	emake || die "emake failed."
}

# override eclass
src_install() {
	gnome2_src_install
}

DOCS="AUTHORS README RELEASE"

pkg_postinst () {
	gnome2_pkg_postinst

	elog "The Gstreamer plugins setup has changed quite a bit on Gentoo,"
	elog "applications now should provide the basic plugins needed."
	elog ""
	elog "The new seperate plugins are all named 'gst-plugins-<plugin>'."
	elog "To get a listing of currently available plugins execute 'emerge -s gst-plugins-'."
	elog "In most cases it shouldn't be needed though to emerge extra plugins."
}

pkg_postrm() {
	gnome2_pkg_postrm
}
