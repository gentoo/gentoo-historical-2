# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/bzrtools/bzrtools-1.8.0.ebuild,v 1.1 2008/10/07 20:08:53 pva Exp $

NEED_PYTHON=2.4
inherit distutils versionator

DESCRIPTION="bzrtools is a useful collection of utilities for bzr."
HOMEPAGE="http://bazaar.canonical.com/BzrTools"
SRC_URI="http://launchpad.net/bzrtools/stable/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="=dev-util/bzr-$(get_version_component_range 1-2)*"

DOCS="AUTHORS CREDITS NEWS NEWS.Shelf README README.Shelf TODO TODO.heads TODO.Shelf"

S=${WORKDIR}/${PN}

PYTHON_MODNAME=bzrlib

src_test() {
	einfo "Running testsuite..."
	"${S}"/test.py || die "Testsuite failed."
}
