# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-misc/h5utils/h5utils-1.10.ebuild,v 1.2 2005/10/20 23:40:29 ribosome Exp $

inherit eutils autotools

DESCRIPTION="utilities for visualization and conversion of scientific data in the HDF5 format"
SRC_URI="http://ab-initio.mit.edu/h5utils/${P}.tar.gz"
HOMEPAGE="http://ab-initio.mit.edu/h5utils/"

LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"

IUSE="octave"
SLOT="0"

DEPEND="sci-libs/hdf5"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/${PV}-octave-path.patch
}

src_compile() {
	eautoconf
	econf $(use_with octave) --without-h5fromh4 || die
	emake || die
}

src_install() {
	einstall || die
	dodoc README COPYING NEWS AUTHORS
}
