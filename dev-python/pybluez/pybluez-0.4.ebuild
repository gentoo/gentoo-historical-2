# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pybluez/pybluez-0.4.ebuild,v 1.1 2005/11/18 15:50:28 liquidx Exp $

inherit distutils python

DESCRIPTION="Python bindings for Bluez Bluetooth Stack"
HOMEPAGE="http://org.csail.mit.edu/pybluez/"
SRC_URI="http://org.csail.mit.edu/pybluez/release/${PN}-src-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

RDEPEND=">=dev-lang/python-2.3
	>=net-wireless/bluez-libs-2.10"

PYTHON_MODNAME="pybluez"

src_install() {
	distutils_src_install

	if use doc; then
		[ -x doc/gendoc ] && doc/gendoc && [ -r doc/bluetooth.html ] && dohtml doc/bluetooth.html
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/*
	fi

	python_version
	python_mod_compile ${D}/usr/$(get_libdir)/python${PYVER}/site-packages/bluetooth.py
}
