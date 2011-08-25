# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-misc/h5utils/h5utils-1.12.1-r2.ebuild,v 1.1 2011/08/25 16:47:50 xarthisius Exp $

EAPI=4

inherit autotools eutils

DESCRIPTION="utilities for visualization and conversion of HDF5 files"
HOMEPAGE="http://ab-initio.mit.edu/h5utils/"
SRC_URI="http://ab-initio.mit.edu/h5utils/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"

IUSE="hdf octave"
SLOT="0"

DEPEND="media-libs/libpng
	sci-libs/hdf5
	hdf? (
		sci-libs/hdf
		virtual/jpeg
	)"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-automagic.patch
	eautoreconf
}

src_configure() {
	econf \
		 --without-v5d \
		$(use_with octave) \
		$(use_with hdf)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README NEWS AUTHORS
}
