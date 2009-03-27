# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/camd/camd-2.2.0.ebuild,v 1.9 2009/03/27 12:36:39 fmccor Exp $

inherit autotools eutils

MY_PN=CAMD
DESCRIPTION="Library to order a sparse matrix prior to Cholesky factorization"
HOMEPAGE="http://www.cise.ufl.edu/research/sparse/camd"
SRC_URI="http://www.cise.ufl.edu/research/sparse/${PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ~ppc ~ppc64 sparc ~x86"
IUSE="doc"
DEPEND="sci-libs/ufconfig"

S="${WORKDIR}/${MY_PN}"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	epatch "${FILESDIR}"/${P}-autotools.patch
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README.txt Doc/ChangeLog || die "dodoc failed"
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins Doc/CAMD_UserGuide.pdf || die "pdf install failed"
	fi
}
