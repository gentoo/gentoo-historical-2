# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/bzrtools/bzrtools-1.9.1.ebuild,v 1.1 2008/11/05 17:02:25 pva Exp $

NEED_PYTHON=2.4
inherit distutils versionator

DESCRIPTION="bzrtools is a useful collection of utilities for bzr."
HOMEPAGE="http://bazaar.canonical.com/BzrTools"
SRC_URI="http://launchpad.net/bzrtools/stable/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="=dev-util/bzr-$(get_version_component_range 1-2)*"

DOCS="AUTHORS CREDITS NEWS NEWS.Shelf README README.Shelf TODO TODO.heads TODO.Shelf"

S=${WORKDIR}/${PN}

PYTHON_MODNAME=bzrlib

src_test() {
	python_version
	einfo "Running testsuite..."
	# put a linked copy of the bzr core into the build directory to properly
	# test the "built" version of bzrtools
	find "$(python_get_libdir)/site-packages/bzrlib/" \
		-mindepth 1 -maxdepth 1 \
		\( \( -type d -and -not -name "plugins" \) -or -name "*.py" \) \
		-exec ln -s '{}' "${S}/build/lib/bzrlib/" \;
	touch "${S}/build/lib/bzrlib/plugins/__init__.py"
	"${S}/test.py" "${S}/build/lib" || die "Testsuite failed."
	# remove the "shadow" copy so it doesn't get installed
	rm "${S}/build/lib/bzrlib/plugins/__init__.py"
	find "${S}/build/lib/bzrlib/" -mindepth 1 -maxdepth 1 -type l -exec rm '{}' \;
}
