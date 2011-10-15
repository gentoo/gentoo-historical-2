# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/clutter-gst/clutter-gst-1.4.2.ebuild,v 1.1 2011/10/15 22:59:07 pacho Exp $

EAPI="4"
GCONF_DEBUG="yes"
PYTHON_DEPEND="2" # Just a build-time dependency
CLUTTER_LA_PUNT="yes"

# inherit clutter after gnome2 so that defaults aren't overriden
# inherit gnome.org in the end so we use gnome mirrors and get the xz tarball
inherit python gnome2 clutter gnome.org

DESCRIPTION="GStreamer Integration library for Clutter"

SLOT="1.0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples +introspection"

RDEPEND="
	>=dev-libs/glib-2.20:2
	>=media-libs/clutter-1.4.0:1.0[introspection?]
	>=media-libs/gstreamer-0.10.26:0.10[introspection?]
	media-libs/gst-plugins-base:0.10[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-0.6.8 )"
DEPEND="${RDEPEND}
	sys-apps/sed
	doc? ( >=dev-util/gtk-doc-1.8 )"

pkg_setup() {
	DOCS="AUTHORS NEWS README"
	EXAMPLES="examples/{*.c,*.png,README}"
	G2CONF="${G2CONF}
		$(use_enable introspection)"

	python_pkg_setup
}

src_prepare() {
	gnome2_src_prepare
	python_convert_shebangs 2 "${S}"/scripts/pso2h.py

	# Remove *_DISABLE_DEPRECATED, bug #385171
	sed -e 's/-D.*_DISABLE_DEPRECATED//g' \
		-i clutter-gst/Makefile.am clutter-gst/Makefile.in || die
}

src_compile() {
	# Clutter tries to access dri without userpriv, upstream bug #661873
	# Massive failure of a hack, see bug 360219, bug 360073, bug 363917
	DISPLAY="999invalid" emake
}
