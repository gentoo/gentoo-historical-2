# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/snakeoil/snakeoil-0.3.5.ebuild,v 1.2 2009/12/30 01:12:05 arfrever Exp $

EAPI="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="Miscellaneous python utility code."
HOMEPAGE="http://www.pkgcore.org/"
SRC_URI="http://www.pkgcore.org/releases/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

DEPEND="!<sys-apps/pkgcore-0.4.7.8"
RDEPEND=${DEPEND}

DOCS="AUTHORS NEWS"

pkg_setup() {
	validate_PYTHON_ABIS

	# A hack to install for all versions of Python in the system.
	# pkgcore needs it to support upgrading to a different Python slot.
	PYTHON_ABIS=""
	local python_interpreter
	for python_interpreter in /usr/bin/python{2.[4-9],3.[1-9]}; do
		if [[ -x "${python_interpreter}" ]]; then
			PYTHON_ABIS+=" ${python_interpreter#/usr/bin/python}"
		fi
	done
	export PYTHON_ABIS="${PYTHON_ABIS# }"
}

src_test() {
	testing() {
		local tempdir
		tempdir="${T}/tests/python-${PYTHON_ABI}"
		mkdir -p "${tempdir}" || die "tempdir creation failed"
		cp -r "${S}" "${tempdir}" || die "test copy failed"
		cd "${tempdir}/${P}"
		PYTHONPATH="$(ls -d build-${PYTHON_ABI}/lib*)" "$(PYTHON)" setup.py build -b "build-${PYTHON_ABI}" test
	}
	python_execute_function testing
}
