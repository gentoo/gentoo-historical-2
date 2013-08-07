# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/lz4/lz4-9999.ebuild,v 1.1 2013/08/07 09:46:39 ryao Exp $

EAPI=4

inherit cmake-utils subversion

DESCRIPTION="Extremely Fast Compression algorithm"
HOMEPAGE="https://code.google.com/p/lz4/"
SRC_URI=""

ESVN_REPO_URI="http://lz4.googlecode.com/svn/trunk/"
ESVN_PROJECT="lz4-read-only"
BUILD_DIR="${S}/cmake"
PREFIX="/usr/bin"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	subversion_src_prepare

	mv "${S}/cmake/"* "${S}"
}

src_install() {
	cmake-utils_src_install

	if [ -f "${S}/usr/bin/lz4c64" ]
	then
		dosym /usr/bin/{lz4c64,lz4c}
	else
		dosym /usr/bin/{lz4c32,lz4c}
	fi
}
