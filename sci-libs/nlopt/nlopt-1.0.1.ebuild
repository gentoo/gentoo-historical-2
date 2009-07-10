# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/nlopt/nlopt-1.0.1.ebuild,v 1.1 2009/07/10 19:27:20 bicatali Exp $

EAPI=2
inherit eutils

DESCRIPTION="Non-linear optimization library"
SRC_URI="http://ab-initio.mit.edu/nlopt/${P}.tar.gz"
HOMEPAGE="http://ab-initio.mit.edu/nlopt/"

LICENSE="LGPL-2.1 MIT"
KEYWORDS="~amd64 ~x86"

SLOT="0"
IUSE="octave cxx"

DEPEND="octave? ( sci-mathematics/octave )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-qsort.patch
}

src_configure() {
	if use octave; then
		export OCT_INSTALL_DIR=/usr/libexec/octave/site/oct/${CHOST}
		export M_INSTALL_DIR=/usr/share/octave/site/m
	else
		export MKOCTFILE=None
	fi
	econf \
		--enable-shared \
		$(use_with cxx)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README
	for r in */README; do newdoc ${r} README.$(dirname ${r}); done
}
