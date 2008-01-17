# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/pssh/pssh-1.3.1.ebuild,v 1.1 2008/01/17 01:21:10 drac Exp $

NEED_PYTHON=2.4

inherit distutils multilib python

DESCRIPTION="This package provides parallel versions of the openssh tools."
HOMEPAGE="http://www.theether.org/pssh"
SRC_URI="http://www.theether.org/pssh/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="net-misc/openssh"
DEPEND="${RDEPEND}
	dev-python/setuptools"

DOCS="BUGS"

pkg_postinst() {
	python_version
	python_mod_optimize "${ROOT}"usr/$(get_libdir)/python${PYVER}/site-packages/psshlib
}

pkg_postrm() {
	python_mod_cleanup
}
