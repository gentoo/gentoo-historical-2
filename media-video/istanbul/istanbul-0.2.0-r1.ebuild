# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/istanbul/istanbul-0.2.0-r1.ebuild,v 1.3 2006/07/18 14:43:04 zaheerm Exp $

inherit eutils gnome2 python autotools

KEYWORDS="~x86 ~amd64"

HOMEPAGE="http://live.gnome.org/Istanbul"
LICENSE="GPL-2"
SLOT=0
DESCRIPTION="Istanbul is a screencast application for the Unix desktop"
IUSE=""

RDEPEND=">=media-libs/gst-plugins-base-0.10.8
	dev-lang/python
	>=dev-python/pygtk-2.6
	>=dev-python/gnome-python-extras-2.11.3
	gnome-base/gconf
	>=dev-python/gst-python-0.10.0
	=media-plugins/gst-plugins-ogg-0.10*
	=media-plugins/gst-plugins-theora-0.10*
	>=media-libs/libtheora-1.0_alpha6
	=media-plugins/gst-plugins-gconf-0.10*"

DEPEND="${RDEPEND}"
SRC_URI="http://zaheer.merali.org/${P}.tar.bz2"

src_unpack() {
	gnome2_src_unpack

	# disable pyc compiling
	mv ${S}/py-compile ${S}/py-compile.orig
	ln -s /bin/true ${S}/py-compile
	echo "py_compile = /bin/true" > common/python.mk

	intltoolize --force --copy || die
	AT_M4DIR="common" eautoreconf
}

src_compile() {
	mkdir -p "${T}/home"
	export HOME="${T}/home"
	export GST_REGISTRY=${T}/home/registry.cache.xml
	addpredict /root/.gconfd
	addpredict /root/.gconf
	econf
	emake
}

pkg_postinst() {
	gnome2_pkg_postinst
	python_version
	python_mod_optimize ${ROOT}/usr/$(get_libdir)/python${PYVER}/site-packages/istanbul
}

pkg_postrm() {
	python_version
	python_mod_cleanup
}
