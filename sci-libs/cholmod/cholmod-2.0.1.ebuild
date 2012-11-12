# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/cholmod/cholmod-2.0.1.ebuild,v 1.1 2012/11/12 02:18:07 bicatali Exp $

EAPI=4

inherit autotools-utils

DESCRIPTION="Sparse Cholesky factorization and update/downdate library"
HOMEPAGE="http://www.cise.ufl.edu/research/sparse/cholmod/"
SRC_URI="http://dev.gentoo.org/~bicatali/distfiles/${P}.tar.gz"

LICENSE="minimal? ( LGPL-2.1 ) !minimal? ( GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~amd64-linux ~x86-fbsd ~x86-linux ~x86-macos"
IUSE="cuda doc metis minimal static-libs +supernodal"

RDEPEND="
	>=sci-libs/amd-2.3
	>=sci-libs/colamd-2.8
	cuda? ( x11-drivers/nvidia-drivers dev-util/nvidia-cuda-toolkit )
	metis? (
		>=sci-libs/camd-2.3
		>=sci-libs/ccolamd-2.8
		|| ( sci-libs/metis sci-libs/parmetis ) )
	supernodal? ( virtual/lapack )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( virtual/latex-base )"

src_prepare() {
	# bug #399483 does not build with parmetis-3.2
	has_version "=sci-libs/parmetis-3.2*" && \
		epatch "${FILESDIR}"/${PN}-1.7.4-parmetis32.patch
}

src_configure() {
	local lapack_libs=no
	local blas_libs=no
	if use supernodal; then
		blas_libs=$(pkg-config --libs blas)
		lapack_libs=$(pkg-config --libs lapack)
	fi
	local myeconfargs+=(
		--with-blas="${blas_libs}"
		--with-lapack="${lapack_libs}"
		$(use_with cuda)
		$(use_with doc)
		$(use_with !minimal modify)
		$(use_with !minimal matrixops)
		$(use_with metis partition)
		$(use_with supernodal)
	)
	autotools-utils_src_configure
}
