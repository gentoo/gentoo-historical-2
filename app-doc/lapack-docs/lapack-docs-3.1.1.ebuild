# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/lapack-docs/lapack-docs-3.1.1.ebuild,v 1.1 2007/05/03 10:34:44 bicatali Exp $

DESCRIPTION="Documentation reference and man pages for lapack implementations"
HOMEPAGE="http://www.netlib.org/lapack"
SRC_URI="mirror://gentoo/lapack-man-${PV}.tgz
	http://www.netlib.org/lapack/lapackqref.ps"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/lapack-${PV}/manpages

src_install() {
	# These belong to the blas-docs
	rm -f man/manl/{lsame,xerbla}.*
	# rename because doman do not yet understand manl files
	rename .l .n man/manl/*.l
	doman man/manl/* || "doman failed"
	dodoc README "${DISTDIR}"/lapackqref.ps || die "dodoc failed"
}
