# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/blas/blas-1.0.ebuild,v 1.2 2007/10/10 12:23:49 bicatali Exp $

DESCRIPTION="Virtual for FORTRAN 77 BLAS implementation"
HOMEPAGE="http://www.gentoo.org/proj/en/science/"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""
RDEPEND="|| (
		sci-libs/blas-reference
		>=sci-libs/blas-atlas-3.7.39
		sci-libs/blas-goto
		>=sci-libs/mkl-9.1.023
		sci-libs/acml
	)"
DEPEND=""
