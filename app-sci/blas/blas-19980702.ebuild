# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/blas/blas-19980702.ebuild,v 1.6 2004/04/16 20:45:58 randy Exp $

DESCRIPTION="Basic Linear Algebra Subprograms"
HOMEPAGE="http://www.netlib.org/blas/"
SRC_URI="http://www.netlib.org/blas/${PN}.tgz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="x86 amd64 s390"

DEPEND="virtual/glibc"

S=${WORKDIR}

src_compile() {
	cp ${FILESDIR}/Makefile ./
	FC="g77" FFLAGS="${CFLAGS}" make static
}

src_install() {
	dolib.a libblas.a
}
