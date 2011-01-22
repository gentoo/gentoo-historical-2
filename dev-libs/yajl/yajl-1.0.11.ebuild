# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/yajl/yajl-1.0.11.ebuild,v 1.4 2011/01/22 18:25:45 hwoarang Exp $

EAPI="2"

inherit cmake-utils

DESCRIPTION="Small event-driven (SAX-style) JSON parser"
HOMEPAGE="http://lloyd.github.com/yajl/"
SRC_URI="http://github.com/lloyd/yajl/tarball/${PV} -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~x86"

IUSE=""

CMAKE_IN_SOURCE_BUILD="1"

src_prepare() {
	cd "${WORKDIR}"/lloyd-${PN}-*
	S=$(pwd)

	epatch "${FILESDIR}"/${PN}-fix_tests.patch
}

src_test() {
	emake test || die
}
