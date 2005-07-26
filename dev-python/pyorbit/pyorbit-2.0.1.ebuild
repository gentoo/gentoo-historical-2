# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyorbit/pyorbit-2.0.1.ebuild,v 1.6 2005/07/26 21:47:04 kloeri Exp $

inherit python gnome2

DESCRIPTION="ORBit2 bindings for Python"
HOMEPAGE="http://www.daa.com.au/~james/pygtk/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha ~amd64 ~hppa ~ia64 ppc sparc x86"
IUSE=""

RDEPEND=">=dev-lang/python-2.2
	>=gnome-base/orbit-2.4.4"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0"

DOCS="AUTHORS ChangeLog INSTALL NEWS README TODO"

src_unpack() {
	unpack ${A}
	# disable pyc compiling
	mv ${S}/py-compile ${S}/py-compile.orig
	ln -s /bin/true ${S}/py-compile
}

src_install() {
	gnome2_src_install

	python_version
	mv ${D}/usr/lib/python${PYVER}/site-packages/CORBA.py \
		${D}/usr/lib/python${PYVER}/site-packages/pyorbit_CORBA.py

	mv ${D}/usr/lib/python${PYVER}/site-packages/PortableServer.py \
		${D}/usr/lib/python${PYVER}/site-packages/pyorbit_PortableServer.py
}

pkg_postinst() {
	python_version
	python_mod_optimize /usr/lib/python${PYVER}/site-packages
}

pkg_postrm() {
	python_version
	python_mod_cleanup
}
