# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-visualization/mayavi/mayavi-1.5.ebuild,v 1.3 2008/10/27 12:08:49 bicatali Exp $

NEED_PYTHON=2.3
EAPI=2
inherit distutils

MY_P=MayaVi-${PV}
DESCRIPTION="VTK based scientific data visualizer"
HOMEPAGE="http://mayavi.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="1"
KEYWORDS="~amd64 ~x86"

IUSE="doc examples"
DEPEND="dev-lang/python[tk]
	>=sci-libs/vtk-5[tk,python]"
RESTRICT="test"

S="${WORKDIR}/${MY_P}"

src_install() {
	distutils_src_install
	dodoc doc/{README,CREDITS,NEWS,TODO}.txt
	use doc && dohtml -r doc/guide/*
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples || die
	fi
}

pkg_postinst() {
	if ! built_with_use sci-libs/vtk patented ; then
		elog "Mayavi may require vtk to be built with the 'patent' USE flag"
		elog "to be fully functional"
	fi
}
