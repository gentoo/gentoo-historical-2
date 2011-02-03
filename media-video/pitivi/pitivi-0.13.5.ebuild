# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/pitivi/pitivi-0.13.5.ebuild,v 1.2 2011/02/03 22:24:28 eva Exp $

EAPI="3"
GCONF_DEBUG="no"
PYTHON_DEPEND="2:2.5"
RESTRICT_PYTHON_ABIS="3.*"

inherit gnome2 python eutils virtualx

DESCRIPTION="A non-linear video editor using the GStreamer multimedia framework"
HOMEPAGE="http://www.pitivi.org"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-python/pygtk-2.14:2
	dev-python/dbus-python
	>=dev-python/gconf-python-2.12
	dev-python/pycairo
	dev-python/pygoocanvas
	net-zope/zope-interface
	gnome-base/librsvg

	>=media-libs/gstreamer-0.10.28
	>=dev-python/gst-python-0.10.19
	>=media-libs/gnonlin-0.10.16
	>=media-libs/gst-plugins-base-0.10
	>=media-libs/gst-plugins-good-0.10
	>=media-plugins/gst-plugins-ffmpeg-0.10
	>=media-plugins/gst-plugins-xvideo-0.10
	>=media-plugins/gst-plugins-libpng-0.10"
DEPEND="${RDEPEND}
	dev-python/setuptools
	>=dev-util/intltool-0.35.5"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS RELEASE"
	python_set_active_version 2
}

src_prepare() {
	gnome2_src_prepare

	epatch "${FILESDIR}/${P}-work-with-old-good.patch"

	# disable pyc compiling
	mv py-compile py-compile.orig
	ln -s $(type -P true) py-compile
}

src_configure() {
	addpredict $(unset HOME; echo ~)/.gconf
	addpredict $(unset HOME; echo ~)/.gconfd
	addpredict $(unset HOME; echo ~)/.gstreamer-0.10

	gnome2_src_configure
}

src_test() {
	export XDG_CONFIG_HOME="${WORKDIR}/.config"
	export XDG_DATA_HOME="${WORKDIR}/.local"
	# Force Xvfb to be used
	unset DISPLAY
	unset DBUS_SESSION_BUS_ADDRESS
	# pitivi/configure.py checks this in get_pixmap_dir()
	mkdir "${S}/.git"
	Xemake check || die "tests failed"
}

src_install() {
	gnome2_src_install
	python_convert_shebangs -r 2 "${D}"
}

pkg_postinst() {
	gnome2_pkg_postinst
	python_mod_optimize "/usr/$(get_libdir)/${PN}/python/${PN}"
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup "/usr/$(get_libdir)/${PN}/python/${PN}"
}
