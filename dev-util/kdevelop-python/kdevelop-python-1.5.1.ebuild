# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/kdevelop-python/kdevelop-python-1.5.1.ebuild,v 1.1 2013/07/11 10:23:31 kensington Exp $

EAPI=5

KDEBASE="kdevelop"
KMNAME="kdev-python"

inherit kde4-base

MY_PN="${KMNAME}"
MY_PV="v${PV}"
MY_P="${MY_PN}-${MY_PV}"

if [[ $PV != *9999* ]]; then
	SRC_URI="mirror://kde/stable/kdevelop/${MY_PN}/${PV}/src/${MY_P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
	S=${WORKDIR}/${MY_P}
else
	EGIT_REPO_URI="git://anongit.kde.org/kdev-python.git"
	KEYWORDS=""
fi

DESCRIPTION="Python plugin for KDevelop 4"
HOMEPAGE="http://www.kdevelop.org"

LICENSE="GPL-2"
IUSE="debug"

COMMON_DEPEND="
	>=dev-util/kdevplatform-1.4.60
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/kdevelop-pg-qt-1.0.0
"
RDEPEND="
	${COMMON_DEPEND}
	dev-util/kdevelop
"

RESTRICT="test"

src_compile() {
	pushd "${WORKDIR}"/${P}_build > /dev/null
	emake parser
	popd > /dev/null

	kde4-base_src_compile
}
