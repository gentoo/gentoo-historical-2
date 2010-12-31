# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyopencl/pyopencl-9999.ebuild,v 1.4 2010/12/31 16:51:22 arfrever Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit git distutils

EGIT_REPO_URI="http://git.tiker.net/trees/pyopencl.git"

DESCRIPTION="Python wrapper for OpenCL"
HOMEPAGE="http://mathema.tician.de/software/pyopencl"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="examples opengl"

RDEPEND=">=dev-python/numpy-1.0.4
	=dev-python/pytools-9999
	>=dev-util/nvidia-cuda-toolkit-3.0"
DEPEND="${RDEPEND}
	dev-libs/boost[python]"

src_unpack()
{
	git_src_unpack
}

src_configure()
{
	if use opengl; then
		myconf="${myconf} --cl-enable-gl"
	fi

	./configure.py --boost-python-libname=boost_python-mt \
		--boost-thread-libname=boost_thread-mt --boost-compiler=gcc \
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
