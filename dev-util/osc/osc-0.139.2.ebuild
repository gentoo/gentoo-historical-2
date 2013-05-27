# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/osc/osc-0.139.2.ebuild,v 1.1 2013/05/27 16:23:57 miska Exp $

EAPI=5

EGIT_REPO_URI="git://github.com/openSUSE/osc.git"

PYTHON_COMPAT=( python{2_6,2_7} )

if [[ "${PV}" == "9999" ]]; then
	EXTRA_ECLASS="git-2"
else
	OBS_PROJECT="openSUSE:Tools"
	EXTRA_ECLASS="obs-download"
fi

inherit distutils-r1 ${EXTRA_ECLASS}
unset EXTRA_ECLASS

DESCRIPTION="Command line tool for Open Build Service"
HOMEPAGE="http://en.opensuse.org/openSUSE:OSC"

[[ "${PV}" == "9999" ]] || SRC_URI="${OBS_URI}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

# Don't move KEYWORDS on the previous line or ekeyword won't work # 399061
[[ "${PV}" == "9999" ]] || \
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-python/urlgrabber[${PYTHON_USEDEP}]
	dev-python/pyxml[${PYTHON_USEDEP}]
	app-arch/rpm[python,${PYTHON_USEDEP}]
	dev-python/m2crypto[${PYTHON_USEDEP}]
"
PDEPEND="${DEPEND}
	app-admin/sudo
	dev-util/obs-service-meta
"

src_prepare() {
	epatch "${FILESDIR}"/${P}-out-of-tree-build.patch
	distutils-r1_src_prepare
}

src_install() {
	distutils-r1_src_install
	dosym osc-wrapper.py /usr/bin/osc
	keepdir /usr/lib/osc/source_validators
	cd "${ED}"/usr/
	find . -type f -exec sed -i 's|/usr/bin/build|/usr/bin/suse-build|g'     {} +
	find . -type f -exec sed -i 's|/usr/lib/build|/usr/libexec/suse-build|g' {} +
	find . -type f -exec sed -i 's|/usr/lib/obs|/usr/libexec/obs|g'          {} +
	rm -f "${ED}"/usr/share/doc/${PN}*/TODO*
}
