# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyopencl/pyopencl-0.92.ebuild,v 1.3 2010/12/31 16:51:22 arfrever Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit distutils

DESCRIPTION="Python wrapper for OpenCL"
HOMEPAGE="http://mathema.tician.de/software/pyopencl"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples opengl"

RDEPEND=">=dev-python/numpy-1.0.4
	dev-python/pytools
	>=dev-util/nvidia-cuda-toolkit-3.0"
DEPEND="${RDEPEND}
	dev-libs/boost[python]"

src_configure()
{
	if use opengl; then
		myconf="${myconf} --cl-enable-gl"
	fi

	./configure.py --boost-python-libname=boost_python-mt \
		--boost-compiler=gcc \
		${myconf}
}

src_install()
{
	distutils_src_install
	insinto /usr/share/doc/${PF}
	if use examples; then
		doins -r examples || die
	fi
}

pkg_postinst()
{
	distutils_pkg_postinst
	if use examples; then
		elog "Some of the examples provided by this package require dev-python/matplotlib."
	fi
}
