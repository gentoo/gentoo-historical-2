# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/gst-python/gst-python-0.10.16.ebuild,v 1.11 2010/01/05 18:36:15 nixnut Exp $

EAPI=2
NEED_PYTHON=2.4
inherit autotools eutils multilib python

DESCRIPTION="A Python Interface to GStreamer"
HOMEPAGE="http://gstreamer.freedesktop.org"
SRC_URI="http://gstreamer.freedesktop.org/src/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0.10"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="examples"

RDEPEND="|| ( >=dev-python/pygobject-2.11.2 >=dev-python/pygtk-2.6.3 )
	>=media-libs/gstreamer-0.10.24
	>=media-libs/gst-plugins-base-0.10.24
	dev-libs/libxml2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.10.9-lazy.patch
	rm -f py-compile ltmain.sh common/m4/{libtool,lt*}.m4 || die "rm -f failed"
	ln -s $(type -P true) py-compile
	AT_M4DIR="common/m4" eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO

	if use examples; then
		docinto examples
		dodoc examples/*
	fi
}

pkg_postinst() {
	python_version
	python_need_rebuild
	python_mod_compile /usr/$(get_libdir)/python${PYVER}/site-packages/pygst.py
	python_mod_optimize	/usr/$(get_libdir)/python${PYVER}/site-packages/gst-0.10
}

pkg_postrm() {
	python_mod_cleanup
}
