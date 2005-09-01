# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/hpl/hpl-1.0-r2.ebuild,v 1.1 2005/09/01 11:59:18 pbienst Exp $

inherit eutils

DESCRIPTION="HPL - A Portable Implementation of the High-Performance Linpack Benchmark for Distributed-Memory Computers"
HOMEPAGE="http://www.netlib.org/benchmark/hpl/"
SRC_URI="http://www.netlib.org/benchmark/hpl/hpl.tgz"
LICENSE="HPL"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
S="${WORKDIR}/${PN}"

DEPEND="virtual/mpi
	virtual/blas
	virtual/lapack"

src_unpack() {
	unpack ${A}
	cd ${S}
	cp setup/Make.Linux_PII_FBLAS Make.gentoo_hpl_fblas_x86
	sed -i \
		-e '/^HPL_OPTS\>/s,=,= -DHPL_DETAILED_TIMING -DHPL_COPY_L,' \
		-e '/^ARCH\>/s,= .*,= gentoo_hpl_fblas_x86,' \
		-e '/^MPdir\>/s,= .*,=,' \
		-e '/^MPlib\>/s,= .*,=,' \
		-e "/^LAlib\>/s,= .*,= /usr/$(get_libdir)/libblas.so /usr/$(get_libdir)/liblapack.so," \
		-e '/^LINKER\>/s,= .*,= mpicc,' \
		-e '/^CC\>/s,= .*,= mpicc,' \
		Make.gentoo_hpl_fblas_x86
}

src_compile() {
	# do NOT use emake here
	HOME=${WORKDIR} make arch=gentoo_hpl_fblas_x86 || die "Failed to build"
}

src_install() {
	doman man/man3/*.3
	dodoc INSTALL BUGS COPYRIGHT HISTORY README TUNING
	dobin bin/gentoo_hpl_fblas_x86/xhpl || die "Failed to install bins"
	insinto /usr/share/hpl
	doins bin/gentoo_hpl_fblas_x86/HPL.dat || die "Failed to install HPL parameters"
	dohtml -r www/*
	dolib lib/gentoo_hpl_fblas_x86/libhpl.a || die "Failed to install lib"
}

pkg_postinst() {
	einfo "Remember to copy /usr/share/hpl/HPL.dat to your working directory first!"
	einfo "For mpich, run linpack by executing this in your working directory"
	einfo "\"mpirun -np 4 /usr/bin/xhpl\""
	einfo "where -np specifies the number of processes."
	einfo "Other methods are needed lam-mpi etc."
}
