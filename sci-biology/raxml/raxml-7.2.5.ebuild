# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/raxml/raxml-7.2.5.ebuild,v 1.1 2010/01/27 15:58:33 weaver Exp $

EAPI="2"

inherit toolchain-funcs

DESCRIPTION="A Program for Sequential, Parallel & Distributed Inference of Large Phylogenetic Trees"
HOMEPAGE="http://wwwkramer.in.tum.de/exelixis/software.html"
SRC_URI="http://wwwkramer.in.tum.de/exelixis/software/RAxML-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
IUSE="+threads"
KEYWORDS="~amd64 ~x86"

# mpi is not supported in version 7.2.2. mpi is enabled by adding -DPARALLEL to CFLAGS
DEPEND="" # mpi? ( virtual/mpi )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/RAxML-${PV}"

src_prepare() {
	sed -i -e 's/CFLAGS =/CFLAGS := ${CFLAGS}/' \
		-e 's/CC = gcc/CC = '$(tc-getCC)'/' \
		Makefile.* || die
}

src_compile() {
	emake -f Makefile.gcc || die
	emake -f Makefile.SSE3.gcc clean && emake -f Makefile.SSE3.gcc || die
	if use threads; then
		emake -f Makefile.PTHREADS.gcc clean && emake -f Makefile.PTHREADS.gcc || die
		emake -f Makefile.SSE3.PTHREADS.gcc clean && emake -f Makefile.SSE3.PTHREADS.gcc || die
	fi
}

src_install() {
	dobin raxmlHPC raxmlHPC-SSE3 || die
	if use threads; then dobin raxmlHPC-PTHREADS raxmlHPC-PTHREADS-SSE3 || die; fi
}
