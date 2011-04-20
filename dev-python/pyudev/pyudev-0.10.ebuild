# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyudev/pyudev-0.10.ebuild,v 1.1 2011/04/20 16:08:08 arfrever Exp $

EAPI="3"
PYTHON_DEPEND="*:2.6"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.[45] *-jython"
DISTUTILS_SRC_TEST="py.test"

inherit distutils

DESCRIPTION="Python binding to libudev"
HOMEPAGE="http://packages.python.org/pyudev/ http://pypi.python.org/pypi/pyudev"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pygobject pyqt4 pyside"

RDEPEND=">=sys-fs/udev-151
	pygobject? ( dev-python/pygobject )
	pyqt4? ( dev-python/PyQt4 )
	pyside? ( dev-python/pyside )"
DEPEND="${RDEPEND}
	dev-python/setuptools
	test? ( dev-python/mock )"

DOCS="CHANGES.rst README.rst"

src_prepare() {
	distutils_src_prepare

	if ! use pygobject; then
		rm -f pyudev/glib.py
	fi
	if ! use pyqt4; then
		rm -f pyudev/pyqt4.py
	fi
	if ! use pyside; then
		rm -f pyudev/pyside.py
	fi
	if ! use pyqt4 && ! use pyside; then
		rm -f pyudev/_qt_base.py
	fi
}
