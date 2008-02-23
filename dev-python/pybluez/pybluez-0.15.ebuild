# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pybluez/pybluez-0.15.ebuild,v 1.1 2008/02/23 17:40:13 dev-zero Exp $

NEED_PYTHON="2.3"

inherit distutils

MY_P="PyBluez-${PV}"

DESCRIPTION="Python bindings for Bluez Bluetooth Stack"
HOMEPAGE="http://code.google.com/p/pybluez/"
SRC_URI="http://pybluez.googlecode.com/files/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~x86"
IUSE="examples"

DEPEND=">=net-wireless/bluez-libs-2.10"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

PYTHON_MODNAME="bluetooth"

src_install() {
	distutils_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/* || die "doins failed"
	fi
}
