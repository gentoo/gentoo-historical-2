# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pybluez/pybluez-0.9.2.ebuild,v 1.5 2007/06/12 16:30:48 jokey Exp $

inherit distutils

DESCRIPTION="Python bindings for Bluez Bluetooth Stack"
HOMEPAGE="http://org.csail.mit.edu/pybluez/"
SRC_URI="http://org.csail.mit.edu/pybluez/release/${PN}-src-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ia64 ppc x86"
IUSE="doc"

DEPEND=">=net-wireless/bluez-libs-2.10"
RDEPEND="${DEPEND}"

src_install() {
	distutils_src_install

	if use doc; then
		[ -x doc/gendoc ] && doc/gendoc && [ -r doc/bluetooth.html ] && dohtml doc/bluetooth.html
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/*
	fi
}
