# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-physics/harminv/harminv-1.3.1.ebuild,v 1.4 2012/05/04 07:55:33 jdhore Exp $

EAPI=4

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils eutils

DESCRIPTION="Extraction of complex frequencies and amplitudes from time series"
HOMEPAGE="http://ab-initio.mit.edu/harminv/"
SRC_URI="http://ab-initio.mit.edu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs"

RDEPEND="virtual/lapack"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-configure.ac.patch )

src_configure() {
	local myeconfargs=(
		--with-blas="$(pkg-config --libs blas)"
		--with-lapack="$(pkg-config --libs lapack)"
		)
	autotools-utils_src_configure
}
