# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/lapack-docs/lapack-docs-3.1.1.ebuild,v 1.13 2008/12/07 18:57:19 vapier Exp $

DESCRIPTION="Documentation reference and man pages for lapack implementations"
HOMEPAGE="http://www.netlib.org/lapack"
SRC_URI="mirror://gentoo/lapack-man-${PV}.tgz
	http://www.netlib.org/lapack/lapackqref.ps"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 s390 sparc x86 ~x86-fbsd"
IUSE=""

S="${WORKDIR}/lapack-${PV}/manpages"

src_install() {
	# These belong to the blas-docs
	rm -f man/manl/{lsame,xerbla}.*

	# rename because doman do not yet understand manl files
	# Not all systems have the rename command, like say FreeBSD
	local f= t=
	for f in man/manl/*.l; do
		t="${f%%.l}.n"
		mv "${f}" "${t}"
	done
	doman man/manl/* || die "doman failed"
	dodoc README "${DISTDIR}"/lapackqref.ps || die "dodoc failed"
}
