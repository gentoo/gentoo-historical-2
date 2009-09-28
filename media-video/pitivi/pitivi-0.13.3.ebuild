# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/pitivi/pitivi-0.13.3.ebuild,v 1.1 2009/09/28 10:47:34 hanno Exp $

EAPI="2"
GCONF_DEBUG="no"

inherit gnome2 python eutils

DESCRIPTION="A non-linear video editor using the GStreamer multimedia framework"
HOMEPAGE="http://www.pitivi.org"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-lang/python-2.5
	>=dev-python/pygtk-2.14.0
	dev-python/dbus-python
	>=dev-python/gconf-python-2.12
	dev-python/pycairo
	dev-python/pygoocanvas
	net-zope/zopeinterface
	gnome-base/librsvg

	>=media-libs/gstreamer-0.10.24
	>=dev-python/gst-python-0.10.16
	>=media-libs/gnonlin-0.10.13
	>=media-libs/gst-plugins-base-0.10.0
	>=media-libs/gst-plugins-good-0.10.0
	>=media-plugins/gst-plugins-ffmpeg-0.10.0
	>=media-plugins/gst-plugins-xvideo-0.10.0
	>=media-plugins/gst-plugins-libpng-0.10.0"
DEPEND="${RDEPEND}
	dev-python/setuptools
	>=dev-util/intltool-0.35.5"

DOCS="AUTHORS ChangeLog NEWS RELEASE"

# Tests need running X
RESTRICT="test"

src_prepare() {
	gnome2_src_prepare

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
	emake check || die "tests failed"
}

pkg_postinst() {
	gnome2_pkg_postinst
	python_mod_optimize "/usr/$(get_libdir)/${PN}/python/${PN}"
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup "/usr/$(get_libdir)/${PN}/python/${PN}"
}
