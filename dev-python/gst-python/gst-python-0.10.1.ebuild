# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/gst-python/gst-python-0.10.1.ebuild,v 1.2 2006/06/06 22:34:13 carlo Exp $

NEED_PYTHON=2.3

inherit python

DESCRIPTION="A Python Interface to GStreamer"
HOMEPAGE="http://gstreamer.freedesktop.org"
SRC_URI="http://gstreamer.freedesktop.org/src/${PN}/${P}.tar.gz"
LICENSE="LGPL-2"
SLOT="0.10"
KEYWORDS="~x86 ~amd64"
IUSE="doc"

RDEPEND=">=dev-python/pygtk-2.6.3
		>=dev-libs/glib-2.6
		>=x11-libs/gtk+-2.6
		>=media-libs/gstreamer-0.10.1
		>=media-libs/gst-plugins-base-0.10.1"

DEPEND="${RDEPEND}
		dev-util/pkgconfig
		doc? ( app-text/xmlto
		       dev-libs/libxml2 )"

src_compile() {
	econf $(use_enable doc docs) || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README TODO
	docinto examples
	cp -pPR examples/* ${D}usr/share/doc/${PF}/examples
	prepalldocs
}

pkg_postinst() {
	python_version
	python_mod_optimize ${ROOT}usr/lib/python${PYVER}/site-packages/gst-0.10
}

pkg_postrm() {
	python_version
	python_mod_cleanup ${ROOT}usr/lib/python${PYVER}/site-packages/gst-0.10
}
